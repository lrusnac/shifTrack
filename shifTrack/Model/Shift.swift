import Foundation
import CoreData


class Shift: NSManagedObject {

    func getDuration() -> NSTimeInterval? {
        if let endTime = finishTime {
            return endTime.timeIntervalSinceDate(startTime!)
        }
        return nil
    }
}
