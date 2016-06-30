//
//  MainViewController.swift
//  Smart Spender
//
//  Created by Alex on 22.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            do {
                if let frc = fetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                tableView.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() failed: \(error)")
            }
        }
    }
    
    private var indexPathForTrip = NSIndexPath()

    
    struct Constants {
        static let RowHeightScale: CGFloat = 0.09
        static let SegueToSummuryVC = "summaryVC"
        static let SegueToSpendingsVC = "spendingVC"
        static let SegueToTripSettingsVC = "tripSettingsVC"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addTripButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        updateUI()
        
        let tweetCount = managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Trip"), error: nil)
        print("\(tweetCount) trips in data base")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpNavigationBar()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
   
    private func updateUI() {
        
        let request = NSFetchRequest(entityName: "Trip")
//        request.predicate = NSPredicate(format: "any")
        request.sortDescriptors = [NSSortDescriptor(
            key: "startDate",
            ascending: true,
            selector: nil
            )]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    // MARK: - tableView functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let trip = fetchedResultsController?.objectAtIndexPath(indexPath) as? Trip {
            var tripName: String?
            managedObjectContext?.performBlockAndWait {
                // it's easy to forget to do this on the proper queue
                tripName = trip.name
                // we're not assuming the context is a main queue context
                // so we'll grab the screenName and return to the main queue
                // to do the cell.textLabel?.text setting
            }
            cell.textLabel?.text = tripName
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext?.performBlock{
                self.managedObjectContext!.deleteObject((self.fetchedResultsController?.objectAtIndexPath(indexPath))! as! NSManagedObject)
                
                do {
                    try self.managedObjectContext!.save()
                } catch {
                    print(error)
                }
            }
         }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let itemToMove = listOfTrips[sourceIndexPath.row]
//        listOfTrips.removeAtIndex(sourceIndexPath.row)
//        listOfTrips.insert(itemToMove, atIndex: destinationIndexPath.row)
//        self.tableView.reloadData()
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.indexPathForTrip = indexPath
        if (fetchedResultsController?.objectAtIndexPath(indexPath) as! Trip).tripIsOver {
            performSegueWithIdentifier("summaryVC", sender: nil)
        } else {
            performSegueWithIdentifier("spendingVC", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.indexPathForTrip = indexPath
        performSegueWithIdentifier("tripSettingsVC", sender: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) * Constants.RowHeightScale;
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert: tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete: tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Helper functions
    
    private func addEditButton(){
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(MainViewController.editButtonPressed))
        editButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func editButtonPressed(){
        tableView.setEditing(true, animated: true)
        addLeftDoneButton()
    }
    
    private func addLeftDoneButton(){
        let leftDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(MainViewController.leftDoneButtonPressed))
        leftDoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = leftDoneButton
    }
    
    func leftDoneButtonPressed(){
        tableView.setEditing(false, animated: true)
        addEditButton()
    }
    
    private func settingTable () {
        
        
    }
    
    private func settingUpNavigationBar(){
        navigationItem.hidesBackButton = true
        self.title = "Trips"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        addEditButton()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case Constants.SegueToSpendingsVC:
                if let spendingVC = segue.destinationViewController as? SpendingViewController {
                    if let trip = fetchedResultsController?.objectAtIndexPath(indexPathForTrip) as? Trip {
                        spendingVC.name = trip.name
                    }                }
                
            case Constants.SegueToTripSettingsVC:
                    if let tripSettingsVC = segue.destinationViewController as? TripSettingsTableViewController {
                        if let trip = fetchedResultsController?.objectAtIndexPath(indexPathForTrip) as? Trip {
                            tripSettingsVC.name = trip.name
                        }
                    }
                
            case Constants.SegueToSummuryVC:
                if let summaryVC = segue.destinationViewController as? SummaryViewController {
                    if let trip = fetchedResultsController?.objectAtIndexPath(indexPathForTrip) as? Trip {
                        summaryVC.name = trip.name
                    }
                    
                }
            default: break
            }
        }
        
    }
    
    
}
