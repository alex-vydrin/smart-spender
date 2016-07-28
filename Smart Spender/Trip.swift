//
//  Trip.swift
//  Smart Spender
//
//  Created by Alex on 16.06.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import Foundation
import CoreData


class Trip: NSManagedObject {
    
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    
    class func createTripWithInfo (name: String, startDate: NSDate, endDate: NSDate, inManagedObjectContext context: NSManagedObjectContext) {
            if let trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: context) as? Trip {
                trip.name = name
                trip.startDate = startDate
                trip.endDate = endDate
                trip.currency = " ₴"
                trip.saveDataBase()
            }
    }
    
    class func getTripWithName (name: String, inManagedObjectContext context: NSManagedObjectContext) -> Trip? {
        let request = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let trip = (try? context.executeFetchRequest(request))?.first as? Trip {
            return trip
        }
        return nil
    }
    
    class func deleteTrip (name: String, inManagedObjectContext context: NSManagedObjectContext) {
        if getTripWithName(name, inManagedObjectContext: context) != nil {
            context.deleteObject(getTripWithName(name, inManagedObjectContext: context)!)
            do {
                try context.save()
            } catch let error {
                print ("Core Data Error: \(error)")
            }
        }
    }
    
    class func isUnique (name: String, inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let trips = try? context.executeFetchRequest(request) as? [Trip] {
            return trips?.count < 2
        }
        return false
    }
    
    var tripIsOver: Bool {
        return daysFrom(NSDate(), to: endDate) < 0
    }
    
    var moneyLeft: Int {
        return Int(tripBudget!) - moneySpent < 0 ? 0 : Int(tripBudget!) - moneySpent
    }
    
    var averageSpending: Int {
        if daysInTrip == 1 || daysInTrip == 0 {
            return moneySpent
        } else {
            return daysSpent == 0 ? moneySpent : moneySpent/daysSpent
        }
    }
    
    var daysInTrip: Int {
        return startDate == endDate ? 1 : daysFrom(startDate, to: endDate)
    }
    
    var daysSpent: Int {
        return daysFrom(startDate, to:NSDate()) < 0 ? 0 : daysFrom(startDate, to:NSDate())
    }
    
    var daysLeft: String {
        let leftDays = daysFrom(NSDate(), to: endDate)
        
        if leftDays > daysInTrip {
            
            return String(daysInTrip)
            
        } else {
            
            return String ((leftDays > 0) ? leftDays : 0)
        }
    }
    
    var totalForDay: Int {
        var total = 0
        
        let today = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: NSDate())
        
        if !getSpendingsArray().isEmpty {
            for (_, spendingsForDay) in getSpendingsArray().enumerate() {
                for (_, spending) in spendingsForDay.enumerate() {
                    let spendingDay = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month], fromDate: spending.date!)
                    if today == spendingDay {
                        total += spending.amount as! Int
                    }
                }
            }
        }
        return total
    }
    
    var remaining: Int {
            if moneyLeft >= Int(dailyBudget!) {
                
                return Int(dailyBudget!) - totalForDay <= 0 ? 0 : Int(dailyBudget!) - totalForDay
                
            } else if totalForDay > Int(dailyBudget!) {
                
                return 0
            }
            return moneyLeft
    }
    
    var moneySpent: Int {
        var totalSpent = 0
        
        self.managedObjectContext?.performBlockAndWait{
            let request = NSFetchRequest(entityName: "Spendings")
            request.predicate = NSPredicate(format: "trip.name = %@", self.name)
            
            if let spendingsArr = (try? self.managedObjectContext!.executeFetchRequest(request)) as? [Spendings] {
                for spending in spendingsArr {
                    totalSpent += spending.amount as! Int
                }
            }
        }
        return totalSpent
    }
    
    func getSpendingsArray() -> [[Spendings]] {
        
        var arrFilter = [String]()
        var filteredSpendings = [Spendings]()
        var multiArr = [[Spendings]]()
        
        self.managedObjectContext?.performBlockAndWait{
            let request = NSFetchRequest(entityName: "Spendings")
            let descriptor = NSSortDescriptor(key: "date", ascending: false)
            request.predicate = NSPredicate(format: "trip.name = %@", self.name)
            request.sortDescriptors = [descriptor]
            
            if let spendingsArr = (try? self.managedObjectContext!.executeFetchRequest(request)) as? [Spendings] {
                self.dateFormatter.dateFormat = "dd MMMM"
                
                for (_, spending) in spendingsArr.enumerate() {
                    let dateStr = self.dateFormatter.stringFromDate(spending.date!)
                    
                    if !arrFilter.contains(dateStr) {
                        arrFilter.append(dateStr)
                        filteredSpendings.append(spending)
                    }
                }
                
                for (_, filterItem) in arrFilter.enumerate() {
                    
                    var buffer: [Spendings] = []
                    
                    for (_, currentItem) in spendingsArr.enumerate() {
                        if self.dateFormatter.stringFromDate(currentItem.date!) == filterItem {
                            buffer.append(currentItem)
                        }
                    }
                    
                    multiArr.append(buffer)
                }
            }
        }
        return multiArr
    }

    
    private func daysFrom (start: NSDate, to lastDate: NSDate)->Int {
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let startDate = dateFormatter.stringFromDate(start)
        let toDate = dateFormatter.stringFromDate(lastDate)
        let roundedStartDate = dateFormatter.dateFromString(startDate)!
        let roundedEndDate = dateFormatter.dateFromString(toDate)!
        
        let differenceInDays = NSCalendar.currentCalendar().components([NSCalendarUnit.Day], fromDate: roundedStartDate, toDate: roundedEndDate, options: NSCalendarOptions.init(rawValue: 0))
        
        return differenceInDays.day
    }
    
    func setBudget (budget: Int) {
        if isTripBudget.boolValue {
            
            tripBudget = budget
            dailyBudget = Int(tripBudget!) / daysInTrip
            
        } else {
            
            dailyBudget = budget
            tripBudget = Int(dailyBudget!) * daysInTrip
        }
    }
    
    func addAmount(amount: Int, category: String, date: NSDate) {
        Spendings.createSpending(amount,
                                 category: category,
                                 date: date,
                                 trip: self,
                                 inManagedObjectContext: self.managedObjectContext!
        )
        self.saveDataBase()
    }
    
    
    func stringFrom (variable: Variable) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        
        switch variable {
        case .tripBudget :
            return Int(tripBudget!).stringWithSepator + currency!
        case .dailyBudget :
            return Int(dailyBudget!).stringWithSepator + currency!
        case .totalForDay :
            return totalForDay.stringWithSepator + currency!
        case .daysLeft :
            return daysLeft
        case .daysSpent :
            return String (daysSpent)
        case .remaining :
            return remaining.stringWithSepator + currency!
        case .averageSpending :
            return averageSpending.stringWithSepator + currency!
        case .moneyLeft :
            return moneyLeft.stringWithSepator + currency!
        case .moneySpent :
            return moneySpent.stringWithSepator + currency!
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
    
    func saveDataBase() {
        do {
            try self.managedObjectContext!.save()
        } catch let error {
            print ("Core Data Error: \(error)")
        }
    }
    
}
