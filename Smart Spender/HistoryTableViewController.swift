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
    
    let formatter = NSDateFormatter()
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        totalLabel.text = "  Total: \(addSpace(String (currentTrip.moneySpent)))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
//        self.tableView.contentInset = UIEdgeInsetsMake(Constants.PxlUnderNavigationBar,0,0,0);
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
        
        if currentTrip.moneySpent != 0 {
            cell.amountLabel.text = addSpace(String (currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].amount!))
            cell.timeLabel.text = formatter.stringFromDate (currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].date!)
            cell.categoryLabel.text = currentTrip.getSpendingsArray()[indexPath.section][indexPath.row].category
        } else {
            cell.textLabel?.text = "No spendings yet..."
            cell.amountLabel.text = ""
            cell.timeLabel.text = ""
            cell.categoryLabel.text = ""
        }
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return currentTrip.getSpendingsArray().isEmpty ? "" : formatter.stringFromDate (currentTrip.getSpendingsArray()[section][0].date!)
//    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return Constants.HeaderHeight
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) * Constants.RowHeightScale;
    }
    
//    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        let title = UILabel()
//        title.font = UIFont.systemFontOfSize(15, weight: UIFontWeightSemibold)
//        title.textColor = UIColor.blackColor()
//        
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font=title.font
//        header.textLabel?.textColor=title.textColor
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        formatter.dateFormat = "d MMMM, EEEE"
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        header.headerTextLabel.text = currentTrip.getSpendingsArray().isEmpty ? "" : formatter.stringFromDate (currentTrip.getSpendingsArray()[section][0].date!)
        
        return cell
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
