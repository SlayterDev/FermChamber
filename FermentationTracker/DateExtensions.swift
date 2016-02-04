//
//  DateExtensions.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

extension NSDate {
    func daysSinceToday() -> Int {
        let start = self
        let end = NSDate()
        
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = .Day
        
        let components = cal.components(unit, fromDate: start, toDate: end, options: NSCalendarOptions())
        
        return components.day
    }
}
