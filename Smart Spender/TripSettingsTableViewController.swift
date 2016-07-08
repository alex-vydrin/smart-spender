//
//  TripSettingsTableViewController.swift
//  Smart Spender
//
//  Created by Alex on 09.06.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
import CoreData

class TripSettingsTableViewController: UITableViewController, UITextFieldDelegate {

    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    var goingForward = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var textFieldForBudget: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var budgetLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.text = name
        startDateTextField.text = currentTrip.stringFrom(.startDate)
        endDateTextField.text = currentTrip.stringFrom(.endDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        textFieldForBudget.text = currentTrip.amountInBudgetLabel ?? "0"
        addDoneButton()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        segmentControl.selectedSegmentIndex = currentTrip.isTripBudget.boolValue ? 1 : 0
        
    }

    @IBAction func segmentControlChanged(sender: UISegmentedControl) {
        budgetLabel.text = sender.selectedSegmentIndex == 0 ? "Daily Budget" : "Trip Budget"
    }
    
    @IBAction func tripNameChanged(sender: UITextField) {
        currentTrip.name = sender.text!
        name = sender.text!
    }
        
    private func addDoneButton(){
        let rightDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(TripSettingsTableViewController.DoneButtonPressed))
        rightDoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func DoneButtonPressed(){
        
        guard !currentTrip.startDate.isGreaterThanDate(currentTrip.endDate) else {
            presentAlertWith ("\"End date\" could't be earlier than \"Start date\"")
            return
        }
        
        guard nameTextField != "" else {
            presentAlertWith ("Please enter Trip Name")
            return
        }
        
        guard Trip.isUnique(name, inManagedObjectContext: managedObjectContext!) else {
            presentAlertWith ("Trip name \"\(name)\" already exists")
            return

        }
        
        goingForward = true
        managedObjectContext?.performBlockAndWait{
            self.currentTrip.isTripBudget = self.segmentControl.selectedSegmentIndex == 1
            if let budget = Int(self.textFieldForBudget.text!) {
                self.currentTrip.setBudget(budget)
                self.currentTrip.amountInBudgetLabel = self.textFieldForBudget.text!
            }
            self.currentTrip.saveDataBase()
        }
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    // MARK - TextField Delegate
    
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        if textFieldForBudget.text!.isEmpty{
            textFieldForBudget.text = "0"
        }
        if textFieldForBudget.text!.characters.count > 1 && textFieldForBudget.text![textFieldForBudget.text!.startIndex] == "0" {
            textFieldForBudget.text!.removeAtIndex(textFieldForBudget.text!.startIndex)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(TripSettingsTableViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged) // Calls function to update textfields with information from UIDatePicker.
        
    }
    
    // Update textfields with information from UIDatePicker.
    func datePickerChanged (sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        
        if startDateTextField.editing == true {
            
            startDateTextField.text = formatter.stringFromDate(sender.date)
            currentTrip.startDate = sender.date
            
        } else {
            sender.minimumDate = formatter.dateFromString(startDateTextField.text!)
            endDateTextField.text = formatter.stringFromDate(sender.date)
            currentTrip.endDate = sender.date
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func presentAlertWith (text:String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !goingForward {
            let stack = self.navigationController!.viewControllers
            if let _ = stack[stack.count-1] as? AddNewTripViewController {
                managedObjectContext?.performBlockAndWait{
                    Trip.deleteTrip(self.currentTrip.name, inManagedObjectContext: self.managedObjectContext!)
                }
            }
        }
        super.viewWillDisappear(animated)
    }

}
