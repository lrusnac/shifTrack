//
//  Shift+CoreDataProperties.swift
//  shifTrack
//
//  Created by Leonid Rusnac on 03/11/15.
//  Copyright © 2015 Leonid Rusnac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Shift {

    @NSManaged var finishTime: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var location: Location?

}
