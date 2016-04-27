//
//  AddNewTripViewController.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class AddNewTripViewController: UIViewController, UITextFieldDelegate {

    var tripName = String ()
    var startDate = NSDate ()
    var endDate = NSDate ()
    var trip = MyTrip()
    
    @IBOutlet weak var tripNameTaxtField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        
    }
    
    func cancelButtonPressed () {
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func doneButtonPressed(){
            tripName = tripNameTaxtField.text!
            trip = MyTrip(name: tripName, firstDay: startDate, lastDay: endDate)
            performSegueWithIdentifier("tripSettings", sender: nil)
    }
    
    // При каждом редактировании поля tripNameTaxtField проверяет readyForNextScreen().
    @IBAction func editingChangedTextField(sender: AnyObject) {
        readyForNextScreen ()
    }
    
    // MARK: - TextField delegate
    
    // Вызывает клавиатуру UIDatePicker в поля для дат.
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged) // Вызывает метод для изменения текстовых полей в зависимости от значений UIDatePicker.
        
    }
    
    // Обновляет текстовые поля для дат со значением UIDatePicker.
    func datePickerChanged (sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        
        if startDateTextField.editing == true { // Вписывает значение UIDatePicker в текстовое поле, которое редактируется.
            
            startDateTextField.text = formatter.stringFromDate(sender.date)
            startDate = sender.date
        
        } else {
            
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
    
    func setUpNavigationBar(){
        navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        addCancelButton()
    }
    
    func addCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonPressed")
        cancelButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func addDoneButton(){
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPressed")
        doneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    // Проверяет все поля на заполненность. При отсутствии пустых полей, меняет кнопку Cancel на Done и наоборот.
    func readyForNextScreen () ->Bool {
        
        if startDateTextField.text != "" && endDateTextField.text != "" && tripNameTaxtField.text != "" {
            
            addDoneButton()
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tripSettignsScreen = segue.destinationViewController as? TripSettingsViewController {
            tripSettignsScreen.tripInSettings = trip
        }
    }
    

}
