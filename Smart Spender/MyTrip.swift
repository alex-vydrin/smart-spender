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
    
    var tripBudget = 0
    var dailyBudget = 0
    var totalForDay = 0
    var amountInBudgetLabel = "0"
    var currency = " ₴"
    var startDate: NSDate
    var endDate: NSDate
    var currentTime = NSDate()
    var spendingDay: NSDate
    
    var isTripBudget = false
    
    var tripIsOver: Bool {
        return daysFrom(currentTime, to: endDate) < 0
    }
    
    var moneyLeft: Int {
        return tripBudget - moneySpent < 0 ? 0 : tripBudget - moneySpent
    }
    
    var averageSpending: Int {
        if daysInTrip == 1 {
            return moneySpent
        } else {
            return daysSpent == 0 ? 0 : moneySpent/daysSpent
        }
    }
    
    var daysInTrip: Int {
        return startDate == endDate ? 1 : daysFrom(startDate, to: endDate)
    }
    
    var daysSpent: Int {
        return daysFrom(startDate, to:currentTime) < 0 ? 0 : daysFrom(startDate, to:NSDate())
    }
    
    var daysLeft: String {
        let leftDays = daysFrom(currentTime, to: endDate)
        
        if leftDays > daysInTrip {
            
            return String(daysInTrip)
            
        } else {
            
            return String ((leftDays > 0) ? leftDays : 0)
        }
    }
    
    var remaining: Int {
        get{
            if moneyLeft >= dailyBudget {
                
                return dailyBudget - totalForDay <= 0 ? 0 : dailyBudget - totalForDay
                
            } else if totalForDay > dailyBudget {
                
                return 0
            }
            return moneyLeft
        }
    }
    
    var moneySpent:Int {
        var totalSpent = 0
        
        for dict in spendingsArray {
            if dict["amount"] != nil {
                totalSpent += dict["amount"] as! Int
            }
        }
        return totalSpent
    }
    
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
        let amountDict: [String:NSObject] = ["amount":amount, "category":category, "date":date]
        
        spendingsArray.append(amountDict)
        totalForDay += amount
        spendingDay = date
    }
    
    func getName ()->String {
        return tripName
    }
    
    func setBudget (budget: Int) {
        
        if isTripBudget {
            
            tripBudget = budget
            dailyBudget = tripBudget / daysInTrip
            
        } else {
            
            dailyBudget = budget
            tripBudget = dailyBudget * daysInTrip
        }
    }
    
    func setName (name: String) {
        tripName = name
    }
    
    private func daysFrom (start: NSDate, to lastDate: NSDate)->Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let startDate = dateFormatter.stringFromDate(start)
        let toDate = dateFormatter.stringFromDate(lastDate)
        let roundedStartDate = dateFormatter.dateFromString(startDate)!
        let roundedEndDate = dateFormatter.dateFromString(toDate)!
        
        let differenceInDays = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: roundedStartDate, toDate: roundedEndDate, options: NSCalendarOptions.init(rawValue: 0))
        
        return differenceInDays.day
    }
    
    func toDictionary ()-> [String:NSObject]{
        var myDict = [String:NSObject]()
        
        myDict["spendingsArray"] = spendingsArray
        myDict["tripName"] = getName()
        myDict["tripBudget"] = tripBudget
        myDict["dailyBudget"] = dailyBudget
        myDict["totalForDay"] = totalForDay
        myDict["amountInBudgetLabel"] = amountInBudgetLabel
        myDict["startDate"] = startDate
        myDict["endDate"] = endDate
        myDict["isTripBudget"] = isTripBudget
        myDict["spendingDay"] = spendingDay
        
        
        return myDict
    }
    
    func copyFrom (dict: [String:NSObject]) {
        
        if let spendings = dict["spendingsArray"] as? [[String:NSObject]] {
            self.spendingsArray = spendings
        }
        
        self.setName(dict["tripName"] as! String)
        self.tripBudget = dict["tripBudget"] as! Int
        self.dailyBudget = dict["dailyBudget"] as! Int
        self.totalForDay = dict["totalForDay"] as! Int
        self.amountInBudgetLabel = dict["amountInBudgetLabel"] as! String
        self.startDate = dict["startDate"] as! NSDate
        self.endDate = dict["endDate"] as! NSDate
        self.spendingDay = dict["spendingDay"] as! NSDate
        self.isTripBudget = dict["isTripBudget"] as! Bool
    }
    
    private func convertToMyTrip (array: NSMutableArray) ->[MyTrip] {
        
        var trip = MyTrip()
        var tripsArray = [MyTrip]()
        
        for dict in array {
            trip.copyFrom(dict as! [String : NSObject])
            tripsArray.append(trip)
            trip = MyTrip()
        }
        
        return tripsArray
    }
    
    func loadFromFile () -> [MyTrip] {
        if let array = NSMutableArray(contentsOfFile: appDocsDir() + "/trips.plist") {
            return convertToMyTrip(array)
        }
        return [MyTrip]()
    }
    
    private func appDocsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let basePath = paths.first!
        return basePath;
        
    }
    
    func stringFrom (variable: Variable) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        
        switch variable {
        case .tripBudget :
            return addSpaceAndCurrencyTo(tripBudget)
        case .dailyBudget :
            return addSpaceAndCurrencyTo(dailyBudget)
        case .totalForDay :
            return addSpaceAndCurrencyTo(totalForDay)
        case .daysLeft :
            return daysLeft
        case .daysSpent :
            return String (daysSpent)
        case .remaining :
            return addSpaceAndCurrencyTo(remaining)
        case .averageSpending :
            return addSpaceAndCurrencyTo(averageSpending)
        case .moneyLeft :
            return addSpaceAndCurrencyTo(moneyLeft)
        case .moneySpent :
            return addSpaceAndCurrencyTo(moneySpent)
        case .tripDates :
            return "\(formatter.stringFromDate(startDate)) - \(formatter.stringFromDate(endDate))"
        case .startDate :
            return "\(formatter.stringFromDate(startDate))"
        case .endDate :
            return "\(formatter.stringFromDate(endDate))"
        }
    }
    
    enum Variable {
        case moneySpent
        case moneyLeft
        case tripBudget
        case dailyBudget
        case totalForDay
        case daysLeft
        case daysSpent
        case averageSpending
        case tripDates
        case startDate
        case endDate
        case remaining
    }
    
    func addSpaceAndCurrencyTo (num: Int) ->String {
        let str = String (num)
        var newNum = ""
        for i in 1...str.characters.count {
            newNum = "\(str[str.endIndex.advancedBy(-i)])" + newNum
            
            if i%3 == 0 && str.characters.count > i {
                newNum = " " + newNum
            }
        }
        return newNum + currency
    }
    
    func checkCurrentDay () {
        let calendar = NSCalendar.currentCalendar()
        let currentDay = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: NSDate())
        let lastSpendingDay = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: spendingDay)
        
        if currentDay.day != lastSpendingDay.day || currentDay.month != lastSpendingDay.month {
            
            totalForDay = 0
            spendingDay = NSDate()
        }
    }
    
    
    
    
}
