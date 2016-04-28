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
    
    @IBOutlet weak var dailyBadgetLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var totalForDayLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var moneySpentLabel: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var daysSpent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels ()
        self.title = currentTrip.getName()
    }

    
    
    
    // MARK: - Helper methods
    
    func updateLabels () {
        dailyBadgetLabel.text = String (currentTrip.dailyBudget)
        averageLabel.text = String (currentTrip.getAverage())
        totalForDayLabel.text = String (currentTrip.totalForDay)
        remainingLabel.text = String (currentTrip.remaining)
        moneyLeftLabel.text = String (currentTrip.moneyLeft)
        moneySpentLabel.text = String (currentTrip.moneySpent)
        daysLeft.text = currentTrip.getDaysLeft()
        daysSpent.text = currentTrip.getDaysSpent()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateLabel.text = formatter.stringFromDate(NSDate())
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
