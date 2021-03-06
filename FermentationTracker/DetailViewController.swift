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
import DropDown

class DetailViewController: UIViewController, DatePickerProtocol, UITextFieldDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var scrollView: UIScrollView?
    
    var nameField: SharedTextField?
    var startDateField: DatePickerTextField?
    var timeLabel: UILabel?
    var ogField: SharedTextField?
    var fgField: SharedTextField?
    var abvLabel: UILabel?
	
	var dropDown: DropDown?
	var anchorView: UIButton?
	var packageButton: UIButton?
    
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
            startDateField?.text = dateFormatter.stringFromDate(detail.startDate)
            
            if detail.og != 0 {
                ogField?.text = String(format: "%.3f", arguments: [detail.og])
            }
            
            if let fg = detailItem?.fg {
                fgField?.text = String(format: "%.3f", arguments: [fg])
            }
		
			anchorView?.setTitle(detail.type.rawValue, forState: .Normal)
			packageButton?.setTitle("Package \(detail.type.rawValue)", forState: .Normal)
			
			self.navigationItem.title = detail.type.rawValue
			
			if (detail.name == "") {
				nameField?.becomeFirstResponder()
			} else {
				nameField?.text = detail.name
			}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);

		
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        scrollView = UIScrollView().then {
            self.view.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
        
        
        nameField = SharedTextField().then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(scrollView!).offset(75)
                make.left.equalTo(scrollView!).offset(10)
                make.width.equalTo(scrollView!).offset(-20)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "Name"
            $0.delegate = self
            $0.returnKeyType = .Done
            $0.autocapitalizationType = .Words
        }
		
		anchorView = UIButton().then {
			scrollView!.addSubview($0)
			$0.snp_makeConstraints { (make) in
				make.top.equalTo(nameField!.snp_bottom).offset(10)
				make.left.equalTo(nameField!)
				make.width.equalTo(nameField!)
				make.height.equalTo(nameField!)
			}
			
			$0.layer.masksToBounds = false
			$0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
			$0.layer.shadowOpacity = 1.0
			$0.layer.shadowRadius = 0
			$0.layer.shadowOffset = CGSizeMake(0, 1.5)
			
			$0.setTitle("Select Type", forState: .Normal)
			$0.backgroundColor = DarkBaseColor
			$0.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			$0.layer.cornerRadius = 15
			
			$0.addTarget(self, action: #selector(toggleDropDown(_:)), forControlEvents: .TouchUpInside)
		}
		
		dropDown = DropDown().then {
			$0.anchorView = anchorView
			$0.direction = .Any
			$0.dataSource = ["Beer", "Wine", "Cider", "Mead"]
			$0.dismissMode = .Automatic
			$0.backgroundColor = BaseColor
			$0.textColor = DarkAccent
			
			$0.selectionAction = { (index, item) in
				self.anchorView!.setTitle(item, forState: .Normal)
				self.packageButton!.setTitle("Package \(item)", forState: .Normal)
				self.detailItem?.type = BeverageType(rawValue: item)!
				self.navigationItem.title = item
			}
		}
		
        startDateField = DatePickerTextField(frame: CGRectZero, parentVC: self).then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(anchorView!.snp_bottom).offset(30)
                make.left.equalTo(scrollView!).offset(10)
                make.width.equalTo(scrollView!).offset(-20)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "Start Date"
            $0.pickerDelegate = self
        }
        
        timeLabel = UILabel().then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(startDateField!.snp_bottom).offset(5)
                make.left.equalTo(scrollView!).offset(10)
                make.width.equalTo(scrollView!).offset(-20)
                make.height.equalTo(44)
            }
            $0.text = "Hello World"
            $0.textAlignment = .Center
        }
        
        ogField = SharedTextField().then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(timeLabel!.snp_bottom).offset(20)
                make.left.equalTo(scrollView!).offset(10)
                make.width.equalTo(nameField!).dividedBy(2).offset(-5)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "OG"
            $0.keyboardType = .DecimalPad
            $0.delegate = self
            
            let accessoryView = DoneAccessoryView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0))
            accessoryView.doneButton!.addTarget($0, action: #selector(UIResponder.resignFirstResponder), forControlEvents: UIControlEvents.TouchUpInside)
            $0.inputAccessoryView = accessoryView
        }
        
        fgField = SharedTextField().then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(ogField!)
                make.left.equalTo(ogField!.snp_right).offset(10)
                make.width.equalTo(ogField!)
                make.height.equalTo(44)
            }
            
            $0.placeholder = "FG"
            $0.keyboardType = .DecimalPad
            $0.delegate = self
            
            let accessoryView = DoneAccessoryView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0))
            accessoryView.doneButton!.addTarget($0, action: #selector(UIResponder.resignFirstResponder), forControlEvents: UIControlEvents.TouchUpInside)
            $0.inputAccessoryView = accessoryView
        }
        
        abvLabel = UILabel().then {
            scrollView!.addSubview($0)
            $0.snp_makeConstraints { (make) in
                make.top.equalTo(ogField!.snp_bottom).offset(5)
                make.left.equalTo(scrollView!).offset(10)
                make.width.equalTo(scrollView!).offset(-20)
                make.height.equalTo(44)
            }
            $0.text = "Hello World"
            $0.textAlignment = .Center
        }
		
		packageButton = UIButton().then {
			scrollView!.addSubview($0)
			$0.snp_makeConstraints { (make) in
				make.top.equalTo(abvLabel!.snp_bottom).offset(20)
				make.left.equalTo(abvLabel!)
				make.width.equalTo(abvLabel!)
				make.height.equalTo(40)
			}
			
			$0.layer.masksToBounds = false
			$0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
			$0.layer.shadowOpacity = 1.0
			$0.layer.shadowRadius = 0
			$0.layer.shadowOffset = CGSizeMake(0, 1.5)
			
			$0.setTitle("Package Beer", forState: .Normal)
			$0.backgroundColor = DarkBaseColor
			$0.setTitleColor(.whiteColor(), forState: .Normal)
			$0.layer.cornerRadius = 15
			
			$0.addTarget(self, action: #selector(package(_:)), forControlEvents: .TouchUpInside)
		}
		
        self.configureView()
        
        didPickDate()
        calculateABV()
    }
	
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let masterView = self.navigationController?.viewControllers.first as? MasterViewController {
            DataManager.sharedInstance.writeObjectsToFile(masterView.objects + masterView.finishedObjects)
        }
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		dropDown!.bottomOffset = CGPoint(x: 0, y: anchorView!.bounds.height)
        scrollView?.contentSize = CGSize(width: self.view.bounds.width, height: max(self.view.bounds.height, packageButton!.frame.maxY + 15))
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let _ = self.detailItem {
            return true
        } else {
            let leftNav = self.splitViewController?.viewControllers.first as! UINavigationController
            if let masterView = leftNav.topViewController as? MasterViewController {
                masterView.insertNewObject(NSObject())
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        detailItem?.name = nameField!.text!
		
        if let og = ogField!.text {
            if let ogFloat = Float(og) {
                detailItem?.og = ogFloat
            }
        }
        if let fg = fgField!.text {
            if let fgFloat = Float(fg) {
                detailItem?.fg = fgFloat
			} else {
				detailItem?.fg = nil
			}
		}
			
        calculateABV()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func didPickDate() {
        guard let date = dateFormatter.dateFromString(startDateField!.text!) else { return }
		
		if let _ = self.detailItem {
			detailItem?.startDate = date
		}
		
		let days: NSDateComponents!
		if let endDate = self.detailItem?.endDate {
			days = date.daysSinceDate(endDate)
		} else {
			days = date.daysSinceToday()
		}
		
        timeLabel?.text = "\(days.day) day(s)"
		
		if days.month > 0 {
			timeLabel?.text = "\(days.month) month(s) " + timeLabel!.text!
		}
    }
    
    func calculateABV() {
        guard let ogVal = Float(ogField!.text!) else { abvLabel?.text = ""; return }
        guard let fgVal = Float(fgField!.text!) else { abvLabel?.text = ""; return }
        
        let abv = Beverage.calculateABV(ogVal, fg: fgVal)
        
        abvLabel!.text = String(format: "%.2f%% ABV", arguments: [abv])
    }
	
	func toggleDropDown(sender: AnyObject) {
		if dropDown!.hidden {
            self.view.endEditing(true)
			dropDown!.show()
		} else {
			dropDown!.hide()
		}
	}
	
	func package(sender: AnyObject) {
        let type = self.detailItem?.type.rawValue.lowercaseString
        
        if self.detailItem?.endDate != nil {
            UIAlertView(title: "Wait!", message: "Your \(type!) has already been packaged!", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        self.detailItem?.endDate = NSDate()
		
		UIAlertView(title: "Packaged!", message: "Your \(type!) has been packaged!\nFerm Chamber will no longer count time for this \(type!).", delegate: nil, cancelButtonTitle: "Ok").show()
		
		let leftNav = self.splitViewController?.viewControllers.first as! UINavigationController
		if let masterView = leftNav.topViewController as? MasterViewController {
			masterView.tableView.reloadData()
		}
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if UIScreen.mainScreen().bounds.height >= 667 { return }
		
		if nameField!.isFirstResponder() || startDateField!.isFirstResponder() {
			return
		}
		
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().height {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize - 25
            }
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
	}
}

