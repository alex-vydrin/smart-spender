//
//  SpendingViewController.swift
//  Smart Spender
//
//  Created by Alex on 27.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class SpendingViewController: UIViewController {
    
    var currentTrip = MyTrip()
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
        updateLabels ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentTrip.getName()
    }

    @IBAction func addAmountButton(sender: UIButton) {
        performSegueWithIdentifier("addAmountVC", sender: nil)
    }
    
    
    
    // MARK: - Helper methods
    
    func updateLabels () {
        dailyBadgetLabel.text = String (currentTrip.dailyBudget) + currency
        averageLabel.text = String (currentTrip.getAverage()) + currency
        totalForDayLabel.text = String (currentTrip.totalForDay) + currency
        remainingLabel.text = String (currentTrip.remaining) + currency
        moneyLeftLabel.text = String (currentTrip.moneyLeft) + currency
        moneySpentLabel.text = String (currentTrip.moneySpent) + currency
        daysLeft.text = currentTrip.getDaysLeft()
        daysSpent.text = currentTrip.getDaysSpent()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateLabel.text = formatter.stringFromDate(NSDate())
    }
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAmountVC" {
            (segue.destinationViewController as! AddAmountViewController).delegate = self
        }
        
        if let addAmountVC = segue.destinationViewController as? AddAmountViewController {
            addAmountVC.tripAddAmount = currentTrip
        }
    }
    
}

extension SpendingViewController: VCTwoDelegate {
    func updateData(data: MyTrip) {
        currentTrip = data
    }
}
