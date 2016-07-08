//
//  CategoryTableViewController.swift
//  Smart Spender
//
//  Created by Alex on 07.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    private var standardCategories = ["Housing", "Food", "Transport", "Entertainment", "Miscellaneous"] {
        didSet {
            print ("standard categories didset")
            NSUserDefaults.standardUserDefaults().setObject(standardCategories, forKey: "categories")
//            self.tableView.reloadData()
        }
    }
    
    private var categories: [String] {
        get {
            let userCategories = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [String] ?? standardCategories
            print (NSUserDefaults.standardUserDefaults().objectForKey("categories"))
            return userCategories
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "categories")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar ()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func setUpNavigationBar () {
        self.title = "Categories"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = categories[indexPath.row]

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
