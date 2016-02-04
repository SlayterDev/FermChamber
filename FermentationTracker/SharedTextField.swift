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
        
        self.layer.cornerRadius = 15.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
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
}
