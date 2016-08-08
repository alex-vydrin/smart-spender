//
//  HistoryTableViewController.swift
//  Smart Spender
//
//  Created by Alex on 12.05.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    private var categories: [String] {
        return NSUserDefaults.standardUserDefaults().objectForKey("categories") as! [String]
    }
    
    private var categoryImages: [String] {
        return NSUserDefaults.standardUserDefaults().objectForKey("categoryImages") as! [String]
    }
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        totalLabel.text = "  Total: \(currentTrip.moneySpent.stringWithSepator) \(currentTrip.currency!)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        navigationController?.navigationBar.translucent = false
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }

    struct Constants {
        static let PxlUnderNavigationBar: CGFloat = 22
        static let RowHeightScale: CGFloat = 0.08
        static let HeaderHeight: CGFloat = 4
}
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentTrip.getSpendingsArray().isEmpty ? 1 : currentTrip.getSpendingsArray().count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTrip.getSpendingsArray().isEmpty ? 1 : currentTrip.getSpendingsArray()[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        formatter.dateFormat = "HH:mm"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryTableViewCell
        let category = currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].category!
        let image = (category == "Uncategorized") ? UIImage(named: "Pic1") : UIImage(named: categoryImages[categories.indexOf(category)!])
        if currentTrip.moneySpent != 0 {
            cell.amountLabel.text = "\(Int (currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].amount!).stringWithSepator) \(currentTrip.currency!)"
            cell.timeLabel.text = formatter.stringFromDate (currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].date!)
            cell.categoryLabel.text = category
            cell.categoryPicture.image = image
            cell.categoryPicture.layer.masksToBounds = true
            cell.categoryPicture.layer.cornerRadius = cell.categoryPicture.bounds.width / 2
        } else {
            cell.textLabel?.text = "No spendings yet..."
            cell.amountLabel.text = ""
            cell.timeLabel.text = ""
            cell.categoryLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) * Constants.RowHeightScale;
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        formatter.dateFormat = "d MMMM, EEEE"
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader") as! TableSectionHeader
        cell.headerTextLabel.text = currentTrip.getSpendingsArray().isEmpty ? "" : formatter.stringFromDate (currentTrip.getSpendingsArray()[section][0].date!)
        
        return cell
    }
    
}
