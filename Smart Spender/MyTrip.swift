//
//  MyTrip.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MyTrip: NSObject {
    
    private var tripName: String
    var spendingsArray = [[String:NSObject]]()
    var finalBudget = 0
    var tripBudget = 0
    var dailyBudget = 0
    var averageSpending = 0
    var startDate: NSDate
    var endDate: NSDate
    var currentTime = NSDate()
    
    override init() {
        tripName = ""
        startDate = NSDate()
        endDate = NSDate()
    }
    
    init(name: String, firstDay: NSDate, lastDay: NSDate) {
        tripName = name
        startDate = firstDay
        endDate = lastDay
    }
    
    func addAmount(amount: Int, category: String) {
        let amountDict: [String:NSObject] = ["amount":amount,
                                            "category":"uncategorized",
                                            "date":NSDate()]
        spendingsArray.append(amountDict)
        finalBudget += amount
    }
    
    func getName ()->String {
        return tripName
    }
    
    func getAverage () {
        
    }
    
    func getDaysLeft () {
        
    }
    
    func getMoneyLeft () {
        
    }
    
    func getDailyBudget () {
        
    }
    
    func setBudgetDaily (budget: Int) {
        dailyBudget = budget
    }
    
    func setTripsBudget(budget:Int){
        tripBudget = budget
        let daysInTrip = Int ((endDate.timeIntervalSinceDate(startDate))) / 86400 // Seconds in day
        dailyBudget = tripBudget / daysInTrip
    }
    
    
    
    
}
