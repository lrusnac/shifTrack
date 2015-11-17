import UIKit

class ShiftDetailViewController: UITableViewController {

    // var canBeSaved show or not the save button
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select \(indexPath.item)")
        //let tv = UITableView()
        
        
        
        //tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
    }
    
}
