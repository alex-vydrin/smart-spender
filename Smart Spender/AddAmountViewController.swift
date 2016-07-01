//
//  AddAmountViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

//protocol VCTwoDelegate {
//    func updateData(data: MyTrip)
//}

class AddAmountViewController: UIViewController, UITextFieldDelegate {

    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    private var number = ""
    private var date = NSDate()
    
    
    
    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet weak var scoreboardLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        setUpButtons(numButtons)
        addSaveButton ()
        addCancelButton ()
        setUpTextField()
        self.title = name
        
    }
    
    // MARK: - IBAction methods
    
    @IBAction func numButtons(sender: UIButton) { // Adds numbers from buttons to the label.
        number += "\(sender.currentTitle!)"
        
        if number[number.startIndex] == "0" {
            number.removeAtIndex(number.startIndex)
            resetScoreboardLabel()
        } else {
            scoreboardLabel.text = addComa(number)
        }
    }
    
    @IBAction func saveAddAnotherButton(sender: UIButton) {
        saveAmount()
        resetScoreboardLabel()
    }
    
    @IBAction func removeNum(sender: UIButton) { // Removes rightmost number from the label. When last number removed updates label to "0".
        if !number.isEmpty {
            number.removeAtIndex(number.endIndex.predecessor())
            
            if number.isEmpty {
                resetScoreboardLabel()
            } else {
                scoreboardLabel.text = addComa(number)
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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        textField.text = formatter.stringFromDate(NSDate())
        textField.delegate = self
    }
    
    // Вызывает клавиатуру UIDatePicker в поле для дат.
    func textFieldDidBeginEditing(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddAmountViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    // Обновляет текстовое поле для дат со значением UIDatePicker.
    func datePickerChanged (sender: UIDatePicker) {
        
        let formatter = NSDateFormatter()
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
    
    func addComa (num: String) ->String {
        var newNum = ""
        
        for i in 1...num.characters.count {
            newNum = "\(num[num.endIndex.advancedBy(-i)])" + newNum
            
            if i%3 == 0 && num.characters.count > i {
                newNum = " " + newNum
            }
        }
        return newNum
    }
    
    private func saveAmount(){
        if Int(number) > 0 {
            currentTrip.addAmount(Int(number)!, category: "uncategorized", date: date)
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
    
    private func closeKeyboard () {
        self.view.endEditing(true)
    }
    
}
