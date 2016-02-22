//
//  ArrayExtensions.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/22/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
	mutating func removeObject(object: Element) {
		if let index = self.indexOf(object) {
			self.removeAtIndex(index)
		}
	}
	
	mutating func removeObjectsInArray(array: [Element]) {
		for object in array {
			self.removeObject(object)
		}
	}
}
