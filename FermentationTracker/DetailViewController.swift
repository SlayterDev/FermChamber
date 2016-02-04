//
//  DetailViewController.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import UIKit
import Then
import SnapKit

class DetailViewController: UIViewController, DatePickerProtocol, UITextFieldDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var nameField: SharedTextField?
    var startDateField: DatePickerTextField?
    var timeLabel: UILabel?
    var ogField: SharedTextField?
    var fgField: SharedTextField?
    var abvLabel: UILabel?
    
    var dateFormatter = NSDateFormatter()

    var detailItem: Beverage? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            nameField?.text = detail.name
            startDateField?.text = dateFormatter.stringFromDate(detail.startDate)
            ogField?.text = String(format: "%.3f", arguments: [detail.og])
            
            if let fg = detailItem!.fg {
                fgField?.text = String(format: "%.3f", arguments: [fg])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        nameField = SharedTextField().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(75)
                make.left.equalTo(self.view).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "Name"
            $0.delegate = self
            $0.returnKeyType = .Done
        }
        
        startDateField = DatePickerTextField(frame: CGRectZero, parentVC: self).then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(nameField!.snp_bottom).offset(30)
                make.left.equalTo(self.view).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "Start Date"
            $0.pickerDelegate = self
        }
        
        timeLabel = UILabel().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(startDateField!.snp_bottom).offset(5)
                make.left.equalTo(self.view).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(44)
            }
            $0.text = "Hello World"
            $0.textAlignment = .Center
        }
        
        ogField = SharedTextField().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(timeLabel!.snp_bottom).offset(20)
                make.left.equalTo(self.view).offset(10)
                make.width.equalTo(nameField!).dividedBy(2).offset(-5)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "OG"
            $0.keyboardType = .DecimalPad
            $0.delegate = self
            
            let accessoryView = DoneAccessoryView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0))
            accessoryView.doneButton!.addTarget($0, action: "resignFirstResponder", forControlEvents: UIControlEvents.TouchUpInside)
            $0.inputAccessoryView = accessoryView
        }
        
        fgField = SharedTextField().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(ogField!)
                make.left.equalTo(ogField!.snp_right).offset(10)
                make.width.equalTo(ogField!)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "FG"
            $0.keyboardType = .DecimalPad
            $0.delegate = self
            
            let accessoryView = DoneAccessoryView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0))
            accessoryView.doneButton!.addTarget($0, action: "resignFirstResponder", forControlEvents: UIControlEvents.TouchUpInside)
            $0.inputAccessoryView = accessoryView
        }
        
        abvLabel = UILabel().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(ogField!.snp_bottom).offset(5)
                make.left.equalTo(self.view).offset(10)
                make.width.equalTo(self.view).offset(-20)
                make.height.equalTo(44)
            }
            $0.text = "Hello World"
            $0.textAlignment = .Center
        }
        
        self.configureView()
        
        didPickDate()
        calculateABV()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        detailItem!.name = nameField!.text!
        print("End editing")
        if let og = ogField!.text {
            if let ogFloat = Float(og) {
                detailItem!.og = ogFloat
            }
        }
        if let fg = fgField!.text {
            if let fgFloat = Float(fg) {
                detailItem!.fg = fgFloat
            }
        }
        
        calculateABV()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func didPickDate() {
        let date = dateFormatter.dateFromString(startDateField!.text!)
        detailItem!.startDate = date!
        
        timeLabel?.text = "\(date!.daysSinceToday()) days"
    }
    
    func calculateABV() {
        guard let ogVal = Float(ogField!.text!) else { abvLabel?.text = ""; return }
        guard let fgVal = Float(fgField!.text!) else { abvLabel?.text = ""; return }
        
        let abv = (ogVal - fgVal) * 131.25
        
        abvLabel!.text = String(format: "%.2f%% ABV", arguments: [abv])
    }
    
}

