//
//  Spendings.swift
//  Smart Spender
//
//  Created by Alex on 16.06.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import Foundation
import CoreData


class Spendings: NSManagedObject {

    class func createSpending (amount: Int, category: String, date: NSDate, inManagedObjectContext context: NSManagedObjectContext) {
        if let spending = NSEntityDescription.insertNewObjectForEntityForName("Spendings", inManagedObjectContext: context) as? Spendings {
            spending.amount = amount
            spending.category = category
            spending.date = date
        }
    }
}
