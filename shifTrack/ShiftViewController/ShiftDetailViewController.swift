import UIKit

class ShiftDetailViewController: UITableViewController {

    enum ShiftDetailRowType: String {
        case LocationName = "locationSelect"
        case StartTime = "startTimeSelect"
        case EndTime = "endTimeSelect"
        case Picker = "pickerSelect"
    }
    
    var tableRows = [ShiftDetailRowType.LocationName, ShiftDetailRowType.StartTime, ShiftDetailRowType.EndTime]
    let dateFormatter = NSDateFormatter()
    
    var startDatePicker: UIDatePicker? = nil
    var endDatePicker: UIDatePicker? = nil
    var locationPicker: UIPickerView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // init picker and datePicker
        startDatePicker = UIDatePicker()
        startDatePicker?.maximumDate = NSDate()
        startDatePicker?.minuteInterval = 5
        startDatePicker?.addTarget(self, action: "startDatePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = UIDatePickerMode.DateAndTime
        endDatePicker?.maximumDate = NSDate()
        endDatePicker?.minuteInterval = 5
        endDatePicker?.addTarget(self, action: "endDatePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        locationPicker = UIPickerView()
        // add the save button with validation
    }
    
    // This implementation works only if you have at most one row per type (ShiftDetailRowType)
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let curSection = indexPath.section
        
        let selectedRow = tableRows[indexPath.row]
        
        if let indexOfPicker = tableRows.indexOf(ShiftDetailRowType.Picker) {
            tableRows.removeAtIndex(indexOfPicker)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexOfPicker, inSection: curSection)], withRowAnimation: UITableViewRowAnimation.Middle)
            if tableRows[indexOfPicker-1] == selectedRow {
                return
            }
        }
        
        if selectedRow != ShiftDetailRowType.Picker {
            if let indexOfSelection = tableRows.indexOf(selectedRow) {
                tableRows.insert(ShiftDetailRowType.Picker, atIndex: indexOfSelection+1)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexOfSelection+1, inSection: curSection)], withRowAnimation: UITableViewRowAnimation.Middle)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // I only have one section
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = tableRows[indexPath.row].rawValue // I only have one section
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)! // I am sure to have this cell?
        
        switch tableRows[indexPath.row] {
        case .LocationName:
            var detailText: String = "no location"
                
            if let unwrappedLocation = shift?.location {
                detailText = "\(unwrappedLocation.name)"
            }
            
            
            cell.detailTextLabel?.text = detailText
        case .StartTime:
            var detailText: String = "not started"
            
            if let startTime = shift?.startTime {
                detailText = dateFormatter.stringFromDate(startTime)
            }
            
            
            cell.detailTextLabel?.text = detailText
        case .EndTime:
            var detailText: String = "not finished"
            
            if let finishTime = shift?.finishTime {
                detailText = dateFormatter.stringFromDate(finishTime)
            }
            
            
            cell.detailTextLabel?.text = detailText
        case .Picker:
            cell.contentView.subviews.forEach {$0.removeFromSuperview()} // clean the cell before using it
            
            // get the type of picker and configure it, then out it on the cell
            switch tableRows[indexPath.row-1] {
            case .LocationName:
                break
//                if let unwrappedLocation = shift?.location {
//                    // position of the location
//                    //locationPicker?.selectedRowInComponent(0)
//                }
            case .StartTime:
                if let unwrappedStartTime = shift?.startTime {
                    startDatePicker?.setDate(unwrappedStartTime, animated: false)
                }
                cell.contentView.addSubview(startDatePicker!)
            case .EndTime:
                if let unwrappedEndTime = shift?.finishTime {
                    endDatePicker?.minimumDate = shift?.startTime
                    endDatePicker?.setDate(unwrappedEndTime, animated: false)
                }
                cell.contentView.addSubview(endDatePicker!)
            default:
                break
            }
                    }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableRows[indexPath.row] {
        case .Picker:
            return 216
        default:
            return 44
        }
    }
    
    // MARK: - Shift specific object
    var shift: Shift? = nil {
        didSet{
            tableView.reloadData()
        }
    }
    
    func endDatePickerChanged(picker: UIDatePicker) {
        print("bazingaaaa \(picker.date)")
    }

    func startDatePickerChanged(picker: UIDatePicker) {
        print("bazingaaaa \(picker.date)")
    }
}
