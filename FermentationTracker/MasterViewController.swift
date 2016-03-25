//
//  MasterViewController.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Beverage]()
	var finishedObjects = [Beverage]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
		
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = "Ferm Chamber"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
		
		makeHeaderView()
        
        if let storedData = DataManager.sharedInstance.readObjectsFromFile() {
            objects = storedData
            
            objects.sortInPlace { $0.startDate < $1.startDate }
			
			for obj in objects {
				if let _ = obj.endDate {
					finishedObjects.append(obj)
				}
			}
			
			objects.removeObjectsInArray(finishedObjects)
        }
    }
	
	func makeHeaderView() {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
		view.backgroundColor = .whiteColor()
		
		let _ = UISegmentedControl(items: ["Alphabetical", "Time", "OG"]).then {
			view.addSubview($0)
			$0.snp_makeConstraints { (make) in
				make.left.equalTo(view).offset(7.5)
				make.top.equalTo(view).offset(7.5)
				make.right.equalTo(view).offset(-7.5)
				make.bottom.equalTo(view).offset(-7.5)
			}
			
			$0.tintColor = LightAccent
			$0.selectedSegmentIndex = 1
			
			$0.addTarget(self, action: #selector(filterList(_:)), forControlEvents: .ValueChanged)
		}
		
		self.tableView.tableHeaderView = view
	}

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(Beverage(name: "", og: 0.0, startDate: NSDate()), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
		self.performSegueWithIdentifier("showDetail", sender: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
				let object = (indexPath.section == 0) ? objects[indexPath.row] : finishedObjects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (section == 0) ? objects.count : finishedObjects.count
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return (section == 1) ? "Completed" : ""
	}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
        cell.textLabel!.font = .systemFontOfSize(22)
        cell.detailTextLabel!.textColor = .darkGrayColor()
        
        cell.accessoryType = .DisclosureIndicator
        
		let object = (indexPath.section == 0) ? objects[indexPath.row] : finishedObjects[indexPath.row]
		
		let days: NSDateComponents!
		if let endDate = object.endDate {
			days = object.startDate.daysSinceDate(endDate)
			cell.detailTextLabel!.textColor = DarkBaseColor
			cell.detailTextLabel!.font = .boldSystemFontOfSize(cell.detailTextLabel!.font.pointSize)
		} else {
			days = object.startDate.daysSinceToday()
		}
		
		cell.imageView!.image = UIImage(named: object.type.rawValue.lowercaseString)?.makeThumbnailOfSize(CGSize(width: 40, height: 40))
		
        cell.textLabel!.text = (object.name == "") ? "New \(object.type.rawValue)" : object.name
		
		var detailText = String(format: "%d day(s) | %.3f", arguments: [days.day, object.og])
		
		if days.month > 0 {
			detailText = "\(days.month) month(s) " + detailText
		}
		
		if let fg = object.fg {
			let abv = Beverage.calculateABV(object.og, fg: fg)
			let abvText = String(format: " | %.2f%%", arguments: [abv])
			detailText += abvText
		}
		
        cell.detailTextLabel!.text = detailText
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
			if indexPath.section == 0 {
				objects.removeAtIndex(indexPath.row)
			} else {
				finishedObjects.removeAtIndex(indexPath.row)
			}
			
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            DataManager.sharedInstance.writeObjectsToFile(objects + finishedObjects)
        }
    }

	func filterList(sender: AnyObject) {
		let control = sender as! UISegmentedControl
		
		switch control.selectedSegmentIndex {
			case 0:
				objects.sortInPlace{ $0.name < $1.name }
				finishedObjects.sortInPlace { $0.name < $1.name }
			
			case 1:
				objects.sortInPlace { $0.startDate < $1.startDate }
				finishedObjects.sortInPlace { $0.startDate < $1.startDate }
			
			case 2:
				objects.sortInPlace { $0.og < $1.og }
				finishedObjects.sortInPlace { $0.og < $1.og }
			
			default:
				break
		}
		
		self.tableView.reloadData()
	}

}

