//
//  AddAmountViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class AddAmountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    let formatter = NSDateFormatter()
    
    private var categories: [String] {
        let standardCategories = ["Housing", "Food", "Transport", "Entertainment", "Miscellaneous"]
        let userCategories = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [String]
        return userCategories ?? standardCategories
    }
    
    private var number = ""
    private var date = NSDate()
    private var picker = UIPickerView()
    
    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet weak var scoreboardLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        picker.dataSource = self
        picker.delegate = self
        categoryTextField.inputView = picker
        
        setUpButtons(numButtons)
        addSaveButton ()
        addCancelButton ()
        setUpTextField()

        self.title = name
    }
    
    // MARK: - IBAction methods
    
    @IBAction func numButtons(sender: UIButton) {
        number += "\(sender.currentTitle!)"
        
        if number[number.startIndex] == "0" {
            number.removeAtIndex(number.startIndex)
            resetScoreboardLabel()
        } else {
            scoreboardLabel.text = Int (number)?.stringWithSepator
        }
    }
    
    @IBAction func saveAddAnotherButton(sender: UIButton) {
        saveAmount()
        resetScoreboardLabel()
    }
    
    // Removes rightmost number from the label. When last number removed updates label to "0".
    @IBAction func removeNum(sender: UIButton) {
        if !number.isEmpty {
            number.removeAtIndex(number.endIndex.predecessor())
            
            if number.isEmpty {
                resetScoreboardLabel()
            } else {
                scoreboardLabel.text = Int (number)?.stringWithSepator
            }
        }
    }
    
    @IBAction func clearButton(sender: AnyObject) { // Reset scoreboard.
        resetScoreboardLabel()
    }
    
    // MARK: - Helper methods
    
    private func setUpButtons (buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
    }
    
    private func setUpTextField(){
        formatter.dateFormat = "dd.MM.yyyy"
        textField.text = formatter.stringFromDate(NSDate())
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddAmountViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func datePickerChanged (sender: UIDatePicker) {
        formatter.dateFormat = "dd.MM.yyyy"
        
        if textField.editing == true { // Вписывает значение UIDatePicker в текстовое поле, которое редактируется.
            
            textField.text = formatter.stringFromDate(sender.date)
            date = sender.date
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resetScoreboardLabel() {
        scoreboardLabel.text = "0"
        number = ""
    }
    
    private func saveAmount(){
        if Int(number) > 0 {
            currentTrip.addAmount(Int(number)!, category: categoryTextField.text!, date: date)
        }
    }
    
    private func addSaveButton (){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(AddAmountViewController.saveButtonPressed))
        saveButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveButtonPressed(){
        saveAmount()
        navigationController!.popViewControllerAnimated(true)
    }
    
    private func addCancelButton (){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AddAmountViewController.cancelButtonPressed))
        cancelButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func cancelButtonPressed(){
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard ()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: PickerView delegate
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    private func closeKeyboard () {
        self.view.endEditing(true)
    }
    
}
