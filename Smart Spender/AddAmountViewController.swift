//
//  AddAmountViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

protocol VCTwoDelegate {
    func updateData(data: MyTrip)
}

class AddAmountViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: VCTwoDelegate?
    
    var tripAddAmount = MyTrip()
    var number = ""
    var date = NSDate()
  
    @IBOutlet weak var scoreboardLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton ()
        setUpTextField()
        self.title = tripAddAmount.getName()
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
    
    func setUpTextField(){
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
        datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
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
    
    func resetScoreboardLabel() {
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
    
    func saveAmount(){
        if Int(number) > 0 {
            tripAddAmount.addAmount(Int(number)!, category: "uncategorized", date: date)
        }
    }
    
    func addSaveButton (){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed")
        saveButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveButtonPressed(){
        saveAmount()
        self.delegate?.updateData(tripAddAmount)
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard ()
    }
    
    func closeKeyboard () {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
