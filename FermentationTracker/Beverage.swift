//
//  Beverage.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

enum BeverageType: String {
    case Beer  = "Beer"
	case Wine  = "Wine"
    case Cider = "Cider"
    case Mead  = "Mead"
}

class Beverage: NSObject {
    var name: String
	
    var startDate: NSDate
	var endDate: NSDate?
    
    var og: Float
    var fg: Float?
    
    var type: BeverageType
    
    init(name: String, og: Float, startDate: NSDate) {
        self.name = name
        self.og = og
        self.startDate = startDate
		self.type = .Beer
    }
    
    init(coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.og = aDecoder.decodeObjectForKey("og") as! Float
        self.startDate = aDecoder.decodeObjectForKey("startDate") as! NSDate
        
        if let fgVal = aDecoder.decodeObjectForKey("fg") {
            self.fg = fgVal as? Float
        }
		
		self.type = BeverageType(rawValue: (aDecoder.decodeObjectForKey("type") as! String))!
		
		if let endDateVal = aDecoder.decodeObjectForKey("endDate") {
			self.endDate = endDateVal as? NSDate
		}
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.og, forKey: "og")
        aCoder.encodeObject(self.startDate, forKey: "startDate")
		aCoder.encodeObject(self.type.rawValue, forKey: "type")
        
        if let _ = self.fg {
            aCoder.encodeObject(self.fg!, forKey: "fg")
        }
		
		if let _ = self.endDate {
			aCoder.encodeObject(self.endDate, forKey: "endDate")
		}
    }
	
	class func calculateABV(og: Float, fg: Float) -> Float {
		if og < 1.070 {
			return (og - fg) * 131.25
		} else {
			return (76.08 * (og - fg) / (1.775 - og)) * (fg / 0.794)
		}
	}
}
