//
//  UIImageExtensions.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/6/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import UIKit

extension UIImage {
	func makeThumbnailOfSize(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
		
		self.drawInRect(CGRect(origin: CGPoint.zero, size: size))
		let newThumbnail = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return newThumbnail
	}
}
