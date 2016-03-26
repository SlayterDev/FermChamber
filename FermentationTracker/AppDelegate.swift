//
//  AppDelegate.swift
//  FermentationTracker
//
//  Created by Bradley Slayter on 2/4/16.
//  Copyright © 2016 Bradley Slayter. All rights reserved.
//

import UIKit
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
		
		UINavigationBar.appearance().barTintColor = LightAccent
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		UIBarButtonItem.appearance().tintColor = .whiteColor()
		UINavigationBar.appearance().tintColor = .whiteColor()
		UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
		
		DropDown.startListeningToKeyboard()
		
        return true
    }
	
	@available(iOS 9.0, *)
	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		handleShortcutItem(shortcutItem)
	}

    func applicationWillResignActive(application: UIApplication) {
        writeData()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        writeData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        writeData()
    }
    
    func writeData() {
        if let rootController = self.window?.rootViewController as? UISplitViewController {
            if let navController = rootController.viewControllers[0] as? UINavigationController {
                if let masterView = navController.viewControllers[0] as? MasterViewController {
                    let objects = masterView.objects
					let finished = masterView.finishedObjects
                    DataManager.sharedInstance.writeObjectsToFile(objects + finished)
                }
            }
        }
    }
	
	@available(iOS 9.0, *)
	private func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
		if let rootController = self.window?.rootViewController as? UISplitViewController {
			if let navController = rootController.viewControllers[0] as? UINavigationController {
				if let masterView = navController.viewControllers[0] as? MasterViewController {
					NSTimer.scheduledTimerWithTimeInterval(0.5, target: masterView, selector: #selector(MasterViewController.insertNewObject(_:)), userInfo: NSObject(), repeats: false)
				}
			}
		}
	}

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

