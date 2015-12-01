import UIKit
import CoreData

class ShiftsTableViewController: UITableViewController {

    var shifts = [Shift]() // TODO put the datasource in another class ??
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Shift")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            shifts = results as! [Shift]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch  \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shift")!
        
        let shift = shifts[indexPath.row]
        
        if let endTime = shift.finishTime {
            cell.detailTextLabel?.text = endTime.timeIntervalSinceDate(shift.startTime!).stringFromInterval()
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        } else {
            cell.detailTextLabel?.text = NSDate().timeIntervalSinceDate(shift.startTime!).stringFromInterval()
            cell.detailTextLabel?.textColor = UIColor(red:0.60, green:0.20, blue:0.20, alpha:1.0)
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        
        cell.textLabel?.text = dateFormatter.stringFromDate(shift.startTime!)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let managedObjectContext = shifts[indexPath.row].managedObjectContext
            managedObjectContext?.deleteObject(shifts[indexPath.row])
            if let _ = try? managedObjectContext?.save() {
            }
            shifts.removeAtIndex(indexPath.item) // delete from core data instead
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showShiftDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    if let shiftDetailViewController = segue.destinationViewController as? ShiftDetailViewController {
                        shiftDetailViewController.shift = shifts[index]
                    }
                }
            }
        }
        
//        if segue.identifier == "newShift" {
//            
//        }
    }
}
