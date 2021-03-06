//
//  DoneAccessoryView.swift
//  Fermentation Tracker
//
//  Created by Bradley Slayter on 2/4/16.
//

import UIKit

/* --- ABOUT THIS SHARED CLASS

Creates the accessory view to be used for specific text field keyboards where a "Done" button cannot be placed natively, such as the number pad.
Defines a var called `doneButton` which must have targets registered in each class where this is used.

*/

class DoneAccessoryView: UIView {
    
    var doneButton: UIButton! = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = MidColor
        doneButton = UIButton(type: .Custom).then {
            
            self.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self)
                make.right.equalTo(self).offset(-8.0)
                make.bottom.equalTo(self)
                make.width.equalTo(50.0)
            }
            $0.setTitle("Done", forState: .Normal)
            $0.setTitleColor(.whiteColor(), forState: .Normal)
            $0.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
