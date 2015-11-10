import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var startStopButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get Last shift
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Shift")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let shifts = results as! [Shift]
            
            if shifts.count > 0 && shifts[0].finishTime == nil {
                startStopButton.setTitle("Stop", forState: UIControlState.Normal)
            } else {
                startStopButton.setTitle("Start", forState: UIControlState.Normal)
            }
            
        } catch let error as NSError {
            print("Could not fetch  \(error), \(error.userInfo)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toggleLastShift() {
        // get the managed context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // get last shift
        let fetchRequest = NSFetchRequest(entityName: "Shift")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let shifts = results as! [Shift]
            
            if shifts.count > 0 && shifts[0].finishTime == nil {
                // update the most current shift
                shifts[0].finishTime = NSDate()
                
            } else {
                // create new shift
                let entity = NSEntityDescription.entityForName("Shift", inManagedObjectContext: managedContext)
                
                let shift = Shift(entity: entity!, insertIntoManagedObjectContext: managedContext)
                shift.startTime = NSDate()
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch  \(error), \(error.userInfo)")
        }

        
        
            }

    @IBAction func newLocation() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
