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
    var tripsListForTable = [MyTrip]()
    var saveDictionary = [[String:NSObject]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        settingTable ()
        tableView.reloadData()
        
        saveToFile ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = NSMutableArray(contentsOfFile: appDocsDir()+"/trips.plist")!
        tripsListForTable = convertToMyTrip(arr)

        
        
        settingUpNavigationBar()
        if tripsListForTable.isEmpty {
        tripsListForTable.append(tripData)
        }
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    
    
    @IBAction func newTripButton(sender: UIButton) {
    }
    
    // MARK: - tableView functions
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = tripsListForTable[indexPath.row].getName()
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
        tripForSpendingVC = tripsListForTable[indexPath.row]
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
        
        if tripData.getName() != "Current trip" {
            
            
            tripsListForTable.append(tripData)
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
    
    func convertToDictionary (mytrip: [MyTrip])-> [[String:NSObject]]{
        
        var arrayOfDicts = [[String:NSObject]]()
        
        for trip in mytrip {
            
            arrayOfDicts.append(trip.toDictionary())
        }
        
        return arrayOfDicts
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
    
    func saveToFile () {
        saveDictionary = convertToDictionary (tripsListForTable)
        let tripsInDictionaries = NSMutableArray (array: saveDictionary)
        tripsInDictionaries.writeToFile(appDocsDir()+"/trips.plist", atomically: true)
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
            spendingVC.currentTrip = tripForSpendingVC
        }
    }
    
    
}
