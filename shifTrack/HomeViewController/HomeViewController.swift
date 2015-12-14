import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
        
        updateUI()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //loadAllGeotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    
    func contextDidSaveContext(notification: NSNotification) {
        updateUI()
    }
    
    func updateUI() {
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
                startStopButton.setTitle("Stop timer", forState: UIControlState.Normal)
                timerLabel.text = NSDate().timeIntervalSinceDate(shifts[0].startTime!).stringFromInterval()
            } else {
                startStopButton.setTitle("Start timer", forState: UIControlState.Normal)
                timerLabel.text = ""
            }
            
        } catch let error as NSError {
            print("Could not fetch  \(error), \(error.userInfo)")
        }
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
