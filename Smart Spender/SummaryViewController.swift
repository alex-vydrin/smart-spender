//
//  SummaryViewController.swift
//  Smart Spender
//
//  Created by Alex on 18.05.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var totalForTripLabel: UILabel!
    @IBOutlet weak var dailyBudgetLabel: UILabel!
    @IBOutlet weak var averageSpendingLabel: UILabel!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var tripBudgetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        setUpLabels ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Summary"
    }
    
    @IBAction func addAmountButton() {
        performSegueWithIdentifier("summaryToAddAmount", sender: nil)
    }
    
    func setUpLabels () {
                
        tripNameLabel.text = name
        dateLabel.text = currentTrip.stringFrom(.tripDates)
        totalForTripLabel.text = currentTrip.stringFrom(.moneySpent)
        dailyBudgetLabel.text = currentTrip.stringFrom(.dailyBudget)
        averageSpendingLabel.text = currentTrip.stringFrom(.averageSpending)
        moneyLeftLabel.text = currentTrip.stringFrom(.moneyLeft)
        tripBudgetLabel.text = currentTrip.stringFrom(.tripBudget)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let addAmountVC = segue.destinationViewController as? AddAmountViewController {
            addAmountVC.name = name
        }

        if let historyVC = segue.destinationViewController as? HistoryTableViewController {
            historyVC.name = name
        }
    }
}
