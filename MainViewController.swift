//
//  MainViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var trips = ["Budapest", "Paris"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.title = "Trips"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    @IBAction func newTripButton(sender: UIButton) {
        
    }

    @IBAction func editTripsButton(sender: AnyObject) {
        if tableView.editing == true {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
    }
    
    // MARK: - tableView functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = trips[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            trips.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } 
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = trips[sourceIndexPath.row]
        trips.removeAtIndex(sourceIndexPath.row)
        trips.insert(itemToMove, atIndex: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
