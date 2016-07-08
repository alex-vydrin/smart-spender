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
    
    var name = ""
    
    var currentTrip: Trip {
        return Trip.getTripWithName(name, inManagedObjectContext: managedObjectContext!)!
    }
    
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        totalLabel.text = "  Total: \(addSpace(String (currentTrip.moneySpent)))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        self.tableView.contentInset = UIEdgeInsetsMake(Constants.PxlUnderNavigationBar,0,0,0);
        navigationController?.navigationBar.translucent = false
    }

    struct Constants {
        static let PxlUnderNavigationBar: CGFloat = 22
        static let RowHeightScale: CGFloat = 0.08
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countSpendings() == 0 ? 1 : countSpendings()!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        if currentTrip.moneySpent != 0 {
            cell.amountLabel.text = addSpace(String (currentTrip.spendingsArray![indexPath.row].amount!))
            cell.dateLabel.text = formatter.stringFromDate (currentTrip.spendingsArray![indexPath.row].date!)
            cell.categoryLabel.text = currentTrip.spendingsArray![indexPath.row].category
        } else {
            cell.textLabel?.text = "No spendings yet..."
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return name
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) * Constants.RowHeightScale;
    }
    
    func addSpace (num: String) ->String {
        var newNum = ""
        
        for i in 1...num.characters.count {
            newNum = "\(num[num.endIndex.advancedBy(-i)])" + newNum
            
            if i%3 == 0 && num.characters.count > i {
                newNum = " " + newNum
            }
        }
        return newNum + currentTrip.currency!
    }
    
    private func countSpendings () -> Int? {
        var count: Int?
        managedObjectContext?.performBlockAndWait {
            let request = NSFetchRequest(entityName: "Spendings")
            request.predicate = NSPredicate(format: "trip.name = %@", self.name)
            count = self.managedObjectContext!.countForFetchRequest(request, error: nil)
        }
        return count
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
