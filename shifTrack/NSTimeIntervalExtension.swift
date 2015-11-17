//
//  NSTimeIntervalExtension.swift
//  shifTrack
//
//  Created by Leonid Rusnac on 17/11/15.
//  Copyright © 2015 Leonid Rusnac. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    func stringFromInterval() -> String {
        let ti = NSInteger(self)
        
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return "\(hours)h \(minutes)min"
    }
}