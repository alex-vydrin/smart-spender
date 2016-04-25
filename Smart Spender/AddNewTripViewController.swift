//
//  AddNewTripViewController.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

/* Вопросы к Ивану:
    1. изменение кнопки Done/Cancel (кнопка двойная на навигатор баре)
    2. непрозрачная cell  при перемещении
    3. при обратном сегвее что б выезжала слевой стороны
    4. отсутствует кнопка назад в навигатор баре, перехожу назад через сегвей
    5. отцентровать лейбел в навигатор баре
*/

class AddNewTripViewController: UIViewController, UITextFieldDelegate {

    var tripName = String ()
    var startDate = NSDate ()
    var endDate = NSDate ()
    
    
    @IBOutlet weak var tripNameTaxtField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var cancelDoneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    
    // Кнопка Cancel/Done в зависимости от условий в readyForNextScreen() переходит к следующему экрану или возвращает к предыдущему.
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        
        if readyForNextScreen () {
            
            tripName = tripNameTaxtField.text!
            performSegueWithIdentifier("tripSettings", sender: nil)
        
        } else {
            
            performSegueWithIdentifier("backToMainScreen", sender: nil)
        }
        
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
    
    // Проверяет все поля на заполненность. При отсутствии пустых полей, меняет кнопку Cancel на Done и наоборот.
    
    func readyForNextScreen () ->Bool {
        
        if startDateTextField.text != "" && endDateTextField.text != "" && tripNameTaxtField.text != "" {
            
            cancelDoneButton.title = "Done"
            return true
        
        } else {
            
            cancelDoneButton.title = "Cancel"
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
        if let tripS = segue.destinationViewController as? TripSettingsViewController {
            tripS.titleName = tripName
            tripS.fromDate = startDate
            tripS.toDate = endDate
        }
    }
    

}
