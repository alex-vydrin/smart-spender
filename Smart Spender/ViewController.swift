//
//  ViewController.swift
//  Smart Spender
//
//  Created by Alex on 20.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var number = ""
    var expenses = [Int]()
    
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
        print(expenses)
        
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
    
    
    @IBAction func clearButton(sender: AnyObject) {
        resetScoreboardLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func resetScoreboardLabel() {
        scoreboardLabel.text = "0"
        number = ""
    }
    
    func saveScoreboardNumber() {
        if Int(number) > 0 {
            expenses.append(Int(number)!)
        }
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
    
    @IBOutlet weak var scoreboardLabel: UILabel!
    
    
}

