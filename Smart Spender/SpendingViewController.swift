//
//  SpendingViewController.swift
//  Smart Spender
//
//  Created by Alex on 27.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
class SpendingViewController: UIViewController {
    
//    var trip: Trip {
//        get {
//            return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
//        }
//        set {
//            Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)! = newValue
//        }
//    }
    
    var index = Int()
    private var currentTrip: MyTrip {
        return DataBase.sharedInstance.trips[index]
    }
    
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
        currentTrip.checkCurrentDay()
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
    
    private func updateLabels () {
        dailyBadgetLabel.text = currentTrip.stringFrom(.dailyBudget)
        averageLabel.text = currentTrip.stringFrom(.averageSpending)
        totalForDayLabel.text = currentTrip.stringFrom(.totalForDay)
        remainingLabel.text = currentTrip.stringFrom(.remaining)
        moneyLeftLabel.text = currentTrip.stringFrom(.moneyLeft)
        moneySpentLabel.text = currentTrip.stringFrom(.moneySpent)
        daysSpent.text = currentTrip.stringFrom(.daysSpent)
        daysLeft.text = currentTrip.daysLeft
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dateLabel.text = formatter.stringFromDate(NSDate())
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

