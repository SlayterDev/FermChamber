//
//  DatePickerTextField.swift
//  FementationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//

import UIKit

/* --- ABOUT THIS SHARED CLASS

Creates an extension of `RoundedBorderTextField` which sets a date picker as the input interface, rather than a default alphanumeric keyboard.
Uses the `DoneAccessoryView` to close the date picker.

Initialization:
- Must pass in a frame and the parent view controller.
- The parent view controller will be "self" in the class which creates an instance of this class
- Uses the parentVC to determine the width of the accessory view

*/

protocol DatePickerProtocol {
    func didPickDate()
}

class DatePickerTextField: SharedTextField {

    let datePicker = UIDatePicker()
    var parentVC: UIViewController? = nil
    var date: NSDate?
    
    var pickerDelegate: DatePickerProtocol?
    
    init(frame: CGRect, parentVC: UIViewController) {
        super.init(frame: frame)
        self.parentVC = parentVC
        
        self.placeholder = "MM/dd/yyyy"
        
        // Create datePicker
        datePicker.setDate(NSDate(), animated: false)
        datePicker.datePickerMode = .Date;
        datePicker.addTarget(self, action: "didChooseDate", forControlEvents: .ValueChanged)
        self.inputView = datePicker
        
        // Create "Done" button to close date picker
        let accessoryView = DoneAccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: self.parentVC!.view.frame.size.width, height:  40.0))
        accessoryView.doneButton!.addTarget(self, action: "closeDatePicker", forControlEvents: .TouchUpInside)
        self.inputAccessoryView = accessoryView
    }
    
    // Close the date picker
    func closeDatePicker() {
        if self.text == "" {
            didChooseDate()
        }
        
        self.resignFirstResponder()
    }
    
    // Get the selected date and populate the text field with it
    func didChooseDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = datePicker.date
        self.date = selectedDate
        let dateString = String(dateFormatter.stringFromDate(selectedDate))
        self.text = dateString
    }
    
    override func resignFirstResponder() -> Bool {
        pickerDelegate?.didPickDate()
        
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        if self.text != "" {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            datePicker.date = dateFormatter.dateFromString(self.text!)!
        }
        
        return super.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
