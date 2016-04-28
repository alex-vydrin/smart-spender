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
    var totalForDay = 0
    var remaining = 0
    var moneyLeft = 0
    var moneySpent = 0
    var daysInTrip = 0
    var daysSpent = 0
    var amountInBudgetLabel = "0"
    
    var startDate: NSDate
    var endDate: NSDate
    var currentTime = NSDate()
    
    var isTripBudget = false
    
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
        moneySpent += amount
        remaining -= amount
    }
    
    func getName ()->String {
        return tripName
    }
    
    func getAverage ()->Int {
        daysSpent = daysFrom(startDate, to: currentTime)
        
        if daysSpent <= 0 {
            return 0
        } else {
            return moneySpent/daysSpent
        }
    }
    
    // Показывает сколько дней в поездке осталось.
    func getDaysLeft ()->String {
        
        if daysFrom(currentTime, to: endDate) > daysFrom(startDate, to: endDate) {
            
            return String (daysFrom(startDate, to: endDate))
        
        } else {
            
            return String (daysFrom(currentTime, to: endDate))
        }
    }
    
    func getDaysSpent ()->String {
        
        if daysFrom(currentTime, to: endDate) > daysFrom(startDate, to: endDate) {
            
            return "0"
        
        } else {
            
            return String (daysFrom(startDate, to: currentTime))
        }
    }
    
    func getDailyBudget ()->Int {
        if isTripBudget {
            return tripBudget/daysInTrip
        } else {
            return dailyBudget
        }
    }
    
    func setBudget (budget: Int) {
        daysInTrip = daysFrom(startDate, to: endDate)
        
        if isTripBudget {
            tripBudget = budget
            moneyLeft = budget
            dailyBudget = tripBudget / daysInTrip
        } else {
            dailyBudget = budget
            tripBudget = dailyBudget * daysInTrip
            moneyLeft = tripBudget
        }
        
        remaining = dailyBudget
        
    }
    
    func daysFrom (from: NSDate, to: NSDate)->Int {
        return (Int (to.timeIntervalSinceDate(from)) / 86400)
    }
    
    
    
    
}
