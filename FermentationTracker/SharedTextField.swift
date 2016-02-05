//
//  SharedTextField.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import UIKit

class SharedTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        
		self.clearButtonMode = .WhileEditing
    }
    
    // Add text inset
    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        
        return newBounds
    }
	
	override func drawRect(rect: CGRect) {
		let bounds = self.bounds
		let context = UIGraphicsGetCurrentContext()
		let radius = 0.275 * CGRectGetHeight(bounds)
		
		
		// Create the "visible" path, which will be the shape that gets the inner shadow
		// In this case it's just a rounded rect, but could be as complex as your want
		let visiblePath = CGPathCreateMutable()
		let innerRect = CGRectInset(bounds, radius, radius)
		CGPathMoveToPoint(visiblePath, nil, innerRect.origin.x, bounds.origin.y)
		CGPathAddLineToPoint(visiblePath, nil, innerRect.origin.x + innerRect.size.width, bounds.origin.y)
		CGPathAddArcToPoint(visiblePath, nil, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius)
		CGPathAddLineToPoint(visiblePath, nil, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height)
		CGPathAddArcToPoint(visiblePath, nil,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius)
		CGPathAddLineToPoint(visiblePath, nil, innerRect.origin.x, bounds.origin.y + bounds.size.height)
		CGPathAddArcToPoint(visiblePath, nil,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius)
		CGPathAddLineToPoint(visiblePath, nil, bounds.origin.x, innerRect.origin.y)
		CGPathAddArcToPoint(visiblePath, nil,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius)
		CGPathCloseSubpath(visiblePath)
		
		// Fill this path
		var aColor = UIColor.whiteColor()
		aColor.setFill()
		CGContextAddPath(context, visiblePath)
		CGContextFillPath(context)
		
		
		// Now create a larger rectangle, which we're going to subtract the visible path from
		// and apply a shadow
		let path = CGPathCreateMutable()
		//(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
		//-42 cuould just be any offset > 0
		CGPathAddRect(path, nil, CGRectInset(bounds, -42, -42))
		
		// Add the visible path (so that it gets subtracted for the shadow)
		CGPathAddPath(path, nil, visiblePath)
		CGPathCloseSubpath(path)
		
		// Add the visible paths as the clipping path to the context
		CGContextAddPath(context, visiblePath)
		CGContextClip(context)
		
		
		// Now setup the shadow properties on the context
		aColor = UIColor(red: 0.0, green:0.0, blue:0.0, alpha:0.5)
		CGContextSaveGState(context)
		CGContextSetShadowWithColor(context, CGSizeMake(0.0, 1.0), 3.0, aColor.CGColor)
		
		// Now fill the rectangle, so the shadow gets drawn
		aColor.setFill()
		CGContextSaveGState(context)
		CGContextAddPath(context, path)
		CGContextEOFillPath(context)
	}
}
