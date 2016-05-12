//
//  SpendingViewController.swift
//  Smart Spender
//
//  Created by Alex on 27.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class SpendingViewController: UIViewController {
    
    var index = Int()
    var str = String()
    var currency = "₴"
    
    @IBOutlet weak var dailyBadgetLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var totalForDayLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var moneySpentLabel: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var daysSpent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        DataBase.sharedInstance.trips[index].checkCurrentDay()
        updateLabels ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        addDoneButton()
        self.title = DataBase.sharedInstance.trips[index].getName()
    }

    @IBAction func addAmountButton(sender: UIButton) {
        performSegueWithIdentifier("addAmountVC", sender: nil)
    }
    
    
    
    // MARK: - Helper methods
    
    func updateLabels () {
        dailyBadgetLabel.text = addSpace (String (DataBase.sharedInstance.trips[index].dailyBudget)) + currency
        averageLabel.text = addSpace ( String (DataBase.sharedInstance.trips[index].getAverage())) + currency
        totalForDayLabel.text = addSpace ( String (DataBase.sharedInstance.trips[index].totalForDay)) + currency
        remainingLabel.text = addSpace ( String (DataBase.sharedInstance.trips[index].remaining)) + currency
        moneyLeftLabel.text = addSpace ( String (DataBase.sharedInstance.trips[index].moneyLeft)) + currency
        moneySpentLabel.text = addSpace ( String (DataBase.sharedInstance.trips[index].moneySpent)) + currency
        daysLeft.text = DataBase.sharedInstance.trips[index].getDaysLeft()
        daysSpent.text = String (DataBase.sharedInstance.trips[index].getDaysSpent())
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateLabel.text = formatter.stringFromDate(NSDate())
    }
    
    func addDoneButton(){
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPressed")
        doneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func doneButtonPressed () {
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func addSpace (num: String) ->String {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let historyVC = segue.destinationViewController as? HistoryTableViewController {
            historyVC.index = index
        }
        
        if let addAmountVC = segue.destinationViewController as? AddAmountViewController {
            addAmountVC.index = index
        }
    }
    
}

