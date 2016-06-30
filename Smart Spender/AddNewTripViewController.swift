//
//  AddNewTripViewController.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
import CoreData

class AddNewTripViewController: UIViewController, UITextFieldDelegate {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    private var tripName = String ()
    private var startDate = NSDate ()
    private var endDate = NSDate ()
    private let formatter = NSDateFormatter()
    
    @IBOutlet weak var tripNameTaxtField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        formatter.dateFormat = "dd MMM, yyyy"
    }
    
    
    @IBAction func editingChangedTextField(sender: AnyObject) {
        readyForNextScreen ()
    }
    
    // MARK: - TextField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddNewTripViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    // Updates text fields with UIDatePicker value.
    func datePickerChanged (sender: UIDatePicker) {
        if startDateTextField.editing == true {
            
            startDateTextField.text = formatter.stringFromDate(sender.date)
            startDate = sender.date
            
        } else {
            
            sender.minimumDate = formatter.dateFromString(startDateTextField.text!)
            endDateTextField.text = formatter.stringFromDate(sender.date)
            endDate = sender.date
        }
        
        readyForNextScreen ()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - helper methods
    
    private func addDoneButton(){
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                         target: self,
                                         action: #selector(AddNewTripViewController.doneButtonPressed)
        )
        doneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func doneButtonPressed(){
        
        guard !startDate.isGreaterThanDate(endDate) else {
            presentAlertWith ("\"End date\" could't be earlier than \"Start date\"")
            return
        }
        
        if Trip.getTripWithName(tripName, inManagedObjectContext: managedObjectContext!) == nil {
            addTripToDataBase ()
            performSegueWithIdentifier("Trip Settings Segue", sender: nil)
            
        } else {
            presentAlertWith("Trip name \"\(tripName)\" already exists")
        }
    }
    
    func addTripToDataBase () {
        managedObjectContext?.performBlockAndWait{
            Trip.createTripWithInfo(self.tripName, startDate: self.startDate, endDate: self.endDate, inManagedObjectContext: self.managedObjectContext!)
            
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print ("Core Data Error: \(error)")
            }
        }
    }
    
    // Checks all fields to be filled with proper values, dates to be in ascending order.
    private func readyForNextScreen () {
        if startDateTextField.text != "" && endDateTextField.text != "" && tripNameTaxtField.text != "" &&
            NSCalendar.currentCalendar().compareDate(startDate,
                                                     toDate: endDate,
                                                     toUnitGranularity: .Day
            ) != NSComparisonResult.OrderedDescending {
            tripName = tripNameTaxtField.text!
            addDoneButton()
        }
    }
    
    private func presentAlertWith (text:String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard ()
    }
    
    private func closeKeyboard () {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tripSettignsScreen = segue.destinationViewController as? TripSettingsTableViewController {
            tripSettignsScreen.name = tripName
        }
    }
}
