//
//  Trip+CoreDataProperties.swift
//  Smart Spender
//
//  Created by Alex on 17.06.16.
//  Copyright © 2016 AppStory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var endDate: NSDate
    @NSManaged var isTripBudget: NSNumber
    @NSManaged var name: String
    @NSManaged var startDate: NSDate
    @NSManaged var tripBudget: NSNumber?
    @NSManaged var dailyBudget: NSNumber?
    @NSManaged var amountInBudgetLabel: String?
    @NSManaged var currency: String?
    @NSManaged var spendingDay: NSDate?
    @NSManaged var spendings: NSSet?

}
