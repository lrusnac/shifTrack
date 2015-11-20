import UIKit

class ShiftDetailViewController: UITableViewController {

    var tempRowIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let currentSection = indexPath.section
        let nextRow = indexPath.row + 1
        
        if let tempRow = tempRowIndex { //if a row was previously selected then first close it
            tempRowIndex = nil
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: tempRow, inSection: currentSection)], withRowAnimation: UITableViewRowAnimation.Bottom)
        } else {
            tempRowIndex = nextRow
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: nextRow, inSection: currentSection)], withRowAnimation: UITableViewRowAnimation.Bottom)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tempRowIndex != nil {
            return 4
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "locationSelect"
        
        
        if let tempRow = tempRowIndex {
            if tempRow == indexPath.row {
                identifier = "timeStartSelect"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
        
        return cell
    }
}
