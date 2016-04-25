//
//  MyTrip.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MyTrip: NSObject {
    
    let tripName: String
    var spendingsArray = [[String:NSObject]]()
    var totalBudget = 0
    var dailyBudget = 0
    var averageSpending = 0
    var startDate: NSDate
    var endDate: NSDate
    var currentTime = NSDate()
    
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
    }
    
    
    
    
    
    
    
}
