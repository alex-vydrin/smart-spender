//
//  AddAmountViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class AddAmountViewController: UIViewController {
    
    @IBOutlet weak var scoreboardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    var number = ""
    var expenses = [Double]()
    
    @IBAction func numButtons(sender: UIButton) { // Adds numbers from buttons to the label.
        number += "\(sender.currentTitle!)"
        
        if number[number.startIndex] == "0" {
            number.removeAtIndex(number.startIndex)
            resetScoreboardLabel()
        } else {
            scoreboardLabel.text = addComa(number)
        }
    }
    
    @IBAction func saveButton(sender: UIButton) { // Add amount on the label to expenses.
        saveScoreboardNumber()
        // will return to another screen (Like button "back").
    }
    
    @IBAction func saveAddAnotherButton(sender: UIButton) {
        saveScoreboardNumber()
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

    func resetScoreboardLabel() {
        scoreboardLabel.text = "0"
        number = ""
    }
    
    func saveScoreboardNumber() {
        if Int(number) > 0 {
            expenses.append(Double(number)!)
        }
    }
    
    func changeButton() {
        
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


    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
