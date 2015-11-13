import Foundation
import CoreData

extension Shift {

    @NSManaged var finishTime: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var deviceName: String?
    @NSManaged var location: Location?

}
