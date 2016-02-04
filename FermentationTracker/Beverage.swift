//
//  Beverage.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

enum BeverageType {
    case Beer
    case Cider
    case Wine
    case Mead
}

class Beverage: NSObject {
    var name: String
    var startDate: NSDate
    
    var og: Float
    var fg: Float?
    
    var type: BeverageType?
    
    init(name: String, og: Float, startDate: NSDate) {
        self.name = name
        self.og = og
        self.startDate = startDate
    }
    
    init(coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.og = aDecoder.decodeObjectForKey("og") as! Float
        self.startDate = aDecoder.decodeObjectForKey("startDate") as! NSDate
        
        if let fgVal = aDecoder.decodeObjectForKey("fg") {
            self.fg = fgVal as? Float
        } else {
            print("no fg")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.og, forKey: "og")
        aCoder.encodeObject(self.startDate, forKey: "startDate")
        
        if let _ = self.fg {
            aCoder.encodeObject(self.fg!, forKey: "fg")
        } else {
            print("No FG")
        }
    }
}

class Beer: Beverage {
    override init(name: String, og: Float, startDate: NSDate) {
        super.init(name: name, og: og, startDate: startDate)
        self.type = .Beer
    }
}
