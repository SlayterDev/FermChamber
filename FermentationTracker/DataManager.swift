//
//  DataManager.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    func getDocumentsPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)
        let path = paths[0]
        let plistPath = path.stringByAppendingString("/data.plist")
        return plistPath
    }
    
    func writeObjectsToFile(objects: [Beverage]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(objects, toFile: getDocumentsPath())
    }
    
    func readObjectsFromFile() -> [Beverage]? {
        if let objects = NSKeyedUnarchiver.unarchiveObjectWithFile(getDocumentsPath()) as? [Beverage] {
            return objects
        }
        
        return nil
    }
}
