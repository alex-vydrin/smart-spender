//
//  Spendings+CoreDataProperties.swift
//  Smart Spender
//
//  Created by Alex on 16.06.16.
//  Copyright © 2016 AppStory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Spendings {

    @NSManaged var amount: NSNumber?
    @NSManaged var category: String?
    @NSManaged var date: NSDate?
    @NSManaged var trip: Trip?

}
