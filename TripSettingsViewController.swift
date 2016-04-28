//
//  TripSettingsViewController.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class TripSettingsViewController: UIViewController, UITableViewDelegate {
    
    var tripInSettings = MyTrip()
    var spendingsArray = ["Flight:", "Hotel:", "Rent a car:"]
    var firstLabel = UILabel()
    
    @IBOutlet weak var TableListOfSpendings: UITableView!
    @IBOutlet weak var dailyTripBudgetLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var textFieldForBudget: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        addDateLabelToTitle ()
        
        if tripInSettings.isTripBudget {
        segmentControl.selectedSegmentIndex = 1
        }
        
        hideTableIfTripBudget ()
        textFieldForBudget.text = tripInSettings.amountInBudgetLabel
    }
    
    override func viewWillDisappear(animated: Bool) {
        firstLabel.removeFromSuperview()
    }
    
    // MARK: - Action functions
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        
        if textFieldForBudget.text!.isEmpty{
            
            textFieldForBudget.text = "0"
        }
        
        if textFieldForBudget.text!.characters.count > 1 && textFieldForBudget.text![textFieldForBudget.text!.startIndex] == "0" {
           
            textFieldForBudget.text!.removeAtIndex(textFieldForBudget.text!.startIndex)
        }
        
        readyForNextScreen ()
    }
    
    @IBAction func dailyTripBudgetChooseButton(sender: UISegmentedControl) {
        hideTableIfTripBudget ()
    }
    
    
    // MARK: - TableView settings
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = spendingsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingsArray.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            spendingsArray.removeAtIndex(indexPath.row)
            TableListOfSpendings.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = spendingsArray[sourceIndexPath.row]
        spendingsArray.removeAtIndex(sourceIndexPath.row)
        spendingsArray.insert(itemToMove, atIndex: destinationIndexPath.row)
        self.TableListOfSpendings.reloadData()
    }
    
    // MARK: - Helper functions
    
    func hideTableIfTripBudget (){
        if segmentControl.selectedSegmentIndex == 0 {
            dailyTripBudgetLabel.text = "Daily Budget"
            TableListOfSpendings.hidden = false
            addEditButton()
            
        } else {
            dailyTripBudgetLabel.text = "Trip Budget"
            TableListOfSpendings.hidden = true
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    // Функция добавляет второй лейбл в шапку navigation bar  с датами поездки.
    func addDateLabelToTitle () {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if let navigationBar = self.navigationController?.navigationBar {
            
            let firstFrame = CGRect(x: navigationBar.frame.width/2 - 53, y: 16, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            firstLabel = UILabel(frame: firstFrame)
            firstLabel.text = "\(formatter.stringFromDate(tripInSettings.startDate)) - \(formatter.stringFromDate(tripInSettings.endDate))"
            firstLabel.font = UIFont.init(name: "HelveticaNeue", size: 10.0)
            firstLabel.textColor = UIColor.whiteColor()
            navigationBar.addSubview(firstLabel)
        }
    }
    
    func setUpNavigationBar(){
        navigationItem.hidesBackButton = true
        self.TableListOfSpendings.tableFooterView = UIView(frame: CGRectZero)
        self.title = tripInSettings.getName()
        addCancelButton()
        addEditButton()
    }
    
    func addCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonPressed")
        cancelButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancelButtonPressed(){
        navigationController!.popViewControllerAnimated(true)
    }
    
    func addEditButton(){
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPressed")
        editButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    func editButtonPressed(){
        TableListOfSpendings.setEditing(true, animated: true)
        addLeftDoneButton()
    }
    
    func addLeftDoneButton(){
        let leftDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "leftDoneButtonPressed")
        leftDoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftDoneButton
    }
    
    func leftDoneButtonPressed(){
        TableListOfSpendings.setEditing(false, animated: true)
        addEditButton()
    }
    
    func addRightDoneButton(){
        let rightDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "rightDoneButtonPressed")
        rightDoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func rightDoneButtonPressed(){
        tripInSettings.amountInBudgetLabel = textFieldForBudget.text!
        tripInSettings.isTripBudget = segmentControl.selectedSegmentIndex == 1
        tripInSettings.setBudget(Int(textFieldForBudget.text!)!)
        
        if let mainSCR = navigationController!.viewControllers.first as? MainViewController {
            mainSCR.tripData = tripInSettings
        }
        
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func readyForNextScreen ()->Bool {
        
        if textFieldForBudget.text != "" {
            
            addRightDoneButton()
            return true
            
        } else {
            
            addCancelButton()
            return false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard ()
    }
    
    func closeKeyboard () {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let mainSCR = segue.destinationViewController as? MainViewController {
//            mainSCR.tripData = tripInSettings
//        }
//    }
    
    
}
