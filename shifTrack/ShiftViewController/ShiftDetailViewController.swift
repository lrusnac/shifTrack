import UIKit
import CoreData

class ShiftDetailViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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
    
    var changesAreMade = false {
        didSet {
            if changesAreMade {
                // show the save button
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveShift")
            } else {
                //hide the save button
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
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
        locationPicker?.dataSource = self
        locationPicker?.delegate = self
        
        
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
    
    // MARK: - Shift object
    var shift: Shift? = nil
    
    func saveShift() {
        changesAreMade = false
        var tempShift: Shift
        if let finalShift = shift {
            tempShift = finalShift
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            tempShift = NSEntityDescription.insertNewObjectForEntityForName("Shift", inManagedObjectContext: managedContext) as! Shift
        }
        
        // todo location
        if let indexOfStartDate = tableRows.indexOf(ShiftDetailRowType.StartTime) {
            let dateString = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexOfStartDate, inSection: 0))?.detailTextLabel?.text
            if let date = dateString {
                if let startDate = dateFormatter.dateFromString(date) {
                    tempShift.startTime = startDate
                } else {
                    // the start date is wrong so don't save nothing
                }
            }
        }
        
        if let indexOfEndDate = tableRows.indexOf(ShiftDetailRowType.EndTime) {
            let dateString = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexOfEndDate, inSection: 0))?.detailTextLabel?.text
            if let date = dateString {
                if let finishDate = dateFormatter.dateFromString(date) {
                    tempShift.finishTime = finishDate
                }
            }
        }
        
        
        // save context
        let managedObjectContext = tempShift.managedObjectContext
        if let _ = try? managedObjectContext?.save() {
        }
        
        // go back
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - DatePicker target-actions
    func startDatePickerChanged(picker: UIDatePicker) {
        if let indexOfStartDate = tableRows.indexOf(ShiftDetailRowType.StartTime) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexOfStartDate, inSection: 0))?.detailTextLabel?.text = dateFormatter.stringFromDate(picker.date)
        }
        changesAreMade = true
    }
    
    func endDatePickerChanged(picker: UIDatePicker) {
        if let indexOfEndDate = tableRows.indexOf(ShiftDetailRowType.EndTime) {
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexOfEndDate, inSection: 0))?.detailTextLabel?.text = dateFormatter.stringFromDate(picker.date)
        }
        changesAreMade = true
    }

    // MARK: - UIPickerView data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    // MARK: - UIPickerView delegate
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "bazinga"
//    }
//    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        let a = UILabel()
//        a.text = "bazinga 2"
//        return a
//    }
}
