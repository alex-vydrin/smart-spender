//
//  MainViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index = Int()
    var tripData = MyTrip()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromFile ()
        settingUpNavigationBar()
        settingTable ()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    
    // MARK: - tableView functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = DataBase.sharedInstance.trips[indexPath.row].getName()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBase.sharedInstance.trips.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataBase.sharedInstance.trips.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = DataBase.sharedInstance.trips[sourceIndexPath.row]
        DataBase.sharedInstance.trips.removeAtIndex(sourceIndexPath.row)
        DataBase.sharedInstance.trips.insert(itemToMove, atIndex: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        performSegueWithIdentifier("spendingVC", sender: nil)
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        performSegueWithIdentifier("tripSettingsVC", sender: nil)
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
        
        if DataBase.sharedInstance.trips.isEmpty {
            
            DataBase.sharedInstance.trips.append(tripData)
        }
    }
    
    func settingUpNavigationBar(){
        navigationItem.hidesBackButton = true
        self.title = "Trips"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        addEditButton()
    }
    
    func convertToMyTrip (array: NSMutableArray) ->[MyTrip] {
        
        var trip = MyTrip()
        var tripsArray = [MyTrip]()
        
        for dict in array {
            trip.copyFrom(dict as! [String : NSObject])
            tripsArray.append(trip)
            trip = MyTrip()
        }
        
        return tripsArray
    }
    
    func loadFromFile () {
        if let arr = NSMutableArray(contentsOfFile: appDocsDir()+"/trips.plist") {
            DataBase.sharedInstance.trips = convertToMyTrip(arr)
        }
        
    }
    
    func appDocsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let basePath = paths.first!
        return basePath;
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let spendingVC = segue.destinationViewController as? SpendingViewController {
            spendingVC.index = index
        }
        
        if let tripSettingsVC = segue.destinationViewController as? TripSettingsViewController {
            tripSettingsVC.index = index
        }
    }
    
    
}
