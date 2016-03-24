//
//  DateExtensions.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedDescending
}

extension NSDate: Comparable {
	func daysSinceToday() -> NSDateComponents {
        return daysSinceDate(NSDate())
    }
	
	func daysSinceDate(end: NSDate) -> NSDateComponents {
		let start = self
		
		let cal = NSCalendar.currentCalendar()
		let units: NSCalendarUnit = [.Day, .Month]
		
		let components = cal.components(units, fromDate: start, toDate: end, options: NSCalendarOptions())
		
		return components
	}
}
