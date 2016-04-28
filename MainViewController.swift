//
//  MainViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tripForSpendingVC = MyTrip()
    var tripData = MyTrip()
    var tripsListForTable = [[String:MyTrip]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        settingTable ()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpNavigationBar()
        tripsListForTable.append(["Current trip":tripData])
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func newTripButton(sender: UIButton) {
    }
    
    // MARK: - tableView functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let dictionary = tripsListForTable[indexPath.row]
        cell.textLabel?.text = dictionary.keys.first
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsListForTable.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tripsListForTable.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = tripsListForTable[sourceIndexPath.row]
        tripsListForTable.removeAtIndex(sourceIndexPath.row)
        tripsListForTable.insert(itemToMove, atIndex: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dictionary = tripsListForTable[indexPath.row]
        tripForSpendingVC = dictionary.values.first!
        performSegueWithIdentifier("spendingVC", sender: nil)
    }
    
    // MARK: - Helper functions
    
    func addEditButton(){
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPressed")
        editButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func editButtonPressed(){
        tableView.setEditing(true, animated: true)
        addLeftDoneButton()
    }
    
    func addLeftDoneButton(){
        let leftDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "leftDoneButtonPressed")
        leftDoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = leftDoneButton
    }
    
    func leftDoneButtonPressed(){
        tableView.setEditing(false, animated: true)
        addEditButton()
    }
    
    func settingTable () {
        
        if tripData.getName() != "" {
            
            tripsListForTable.append([tripData.getName():tripData])
            tripData = MyTrip()
        }
    }
    
    func settingUpNavigationBar(){
        navigationItem.hidesBackButton = true
        self.title = "Trips"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        addEditButton()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let spendingVC = segue.destinationViewController as? SpendingViewController {
            spendingVC.currentTrip = tripForSpendingVC
        }
    }
    
    
}
