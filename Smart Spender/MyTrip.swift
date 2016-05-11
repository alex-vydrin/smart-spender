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
    var spendingDay: NSDate
    
    var isTripBudget = false
    
    override init() {
        tripName = "Current trip"
        startDate = NSDate()
        endDate = NSDate()
        spendingDay = NSDate()
    }
    
    init(name: String, firstDay: NSDate, lastDay: NSDate) {
        tripName = name
        startDate = firstDay
        endDate = lastDay
        spendingDay = NSDate()
    }
    
    func addAmount(amount: Int, category: String, date: NSDate) {
        let amountDict: [String:NSObject] = ["amount":amount,
                                            "category":category,
                                            "date":date]
        spendingsArray.append(amountDict)
        finalBudget += amount
        moneySpent += amount
        totalForDay += amount
        updateMoneyLeft ()
        updateRamaining ()
        spendingDay = date
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
    
    func setName (name: String) {
        tripName = name
    }
    
    func setBudget (budget: Int) {
        daysInTrip = daysFrom(startDate, to: endDate)
        
        if isTripBudget {
            
            tripBudget = budget
            dailyBudget = tripBudget / daysInTrip
        
        } else {
           
            dailyBudget = budget
            tripBudget = dailyBudget * daysInTrip
        }
        
        updateRamaining ()
        updateMoneyLeft ()
    }
    
    func updateMoneyLeft () {
        moneyLeft = tripBudget - moneySpent
        
        if moneyLeft < 0 {
            moneyLeft = 0
        }
    }
    
    func updateRamaining () {
        remaining = dailyBudget - totalForDay
        
        if remaining < 0 {
            remaining = 0
        }
    }
    
    func daysFrom (from: NSDate, to: NSDate)->Int {
        let days = Int (to.timeIntervalSinceDate(from)) / 86400
        if days == 0 {
            return 1
        }
        return Int (to.timeIntervalSinceDate(from)) / 86400
    }
    
    func toDictionary ()-> [String:NSObject]{
        var myDict = [String:NSObject]()
        
        myDict["spendingsArray"] = spendingsArray
        myDict["tripName"] = getName()
        myDict["finalBudget"] = finalBudget
        myDict["tripBudget"] = tripBudget
        myDict["dailyBudget"] = dailyBudget
        myDict["averageSpending"] = averageSpending
        myDict["totalForDay"] = totalForDay
        myDict["remaining"] = remaining
        myDict["moneyLeft"] = moneyLeft
        myDict["moneySpent"] = moneySpent
        myDict["daysSpent"] = daysSpent
        myDict["amountInBudgetLabel"] = amountInBudgetLabel
        myDict["startDate"] = startDate
        myDict["endDate"] = endDate
        myDict["isTripBudget"] = isTripBudget
        myDict["daysInTrip"] = daysInTrip
        myDict["spendingDay"] = spendingDay
        
        
        return myDict
    }
    
    func copyFrom (dict: [String:NSObject]) {
        
        if let spendings = dict["spendingsArray"] as? [[String:NSObject]] {
            self.spendingsArray = spendings
        }
        
        self.setName(dict["tripName"] as! String)
        self.finalBudget = dict["finalBudget"] as! Int
        self.tripBudget = dict["tripBudget"] as! Int
        self.dailyBudget = dict["dailyBudget"] as! Int
        self.averageSpending = dict["averageSpending"] as! Int
        self.totalForDay = dict["totalForDay"] as! Int
        self.remaining = dict["remaining"] as! Int
        self.moneyLeft = dict["moneyLeft"] as! Int
        self.moneySpent = dict["moneySpent"] as! Int
        self.daysSpent = dict["daysSpent"] as! Int
        self.daysInTrip = dict["daysInTrip"] as! Int
        self.amountInBudgetLabel = dict["amountInBudgetLabel"] as! String
        self.startDate = dict["startDate"] as! NSDate
        self.endDate = dict["endDate"] as! NSDate
        self.spendingDay = dict["spendingDay"] as! NSDate
        self.isTripBudget = dict["isTripBudget"] as! Bool
    }
    
    func checkCurrentDay () {
        let calendar = NSCalendar.currentCalendar()
        let currentDay = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: NSDate())
        let lastSpendingDay = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: spendingDay)
        
        if currentDay.day != lastSpendingDay.day && currentDay.month != lastSpendingDay.month {
            
            remaining = dailyBudget
            totalForDay = 0
            spendingDay = NSDate()
        }
    }


    
    
}
