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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = "Ferm Chamber"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        if let storedData = DataManager.sharedInstance.readObjectsFromFile() {
            objects = storedData
            
            objects.sortInPlace { $0.startDate.daysSinceToday() < $1.startDate.daysSinceToday() }
        }
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
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.font = UIFont.systemFontOfSize(22)
        cell.detailTextLabel!.textColor = UIColor.darkGrayColor()
        
        let object = objects[indexPath.row]
		
		let days: Int!
		if let endDate = object.endDate {
			days = object.startDate.daysSinceDate(endDate)
			cell.detailTextLabel!.textColor = DarkBaseColor
			cell.detailTextLabel!.font = UIFont.boldSystemFontOfSize(cell.detailTextLabel!.font.pointSize)
		} else {
			days = object.startDate.daysSinceToday()
		}
		
        cell.textLabel!.text = (object.name == "") ? "New \(object.type.rawValue)" : object.name
        
        cell.detailTextLabel!.text = String(format: "%d day(s) | %.3f", arguments: [days, object.og])
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            DataManager.sharedInstance.writeObjectsToFile(objects)
        }
    }


}

