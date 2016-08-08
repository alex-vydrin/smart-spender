//
//  CategoryTableViewController.swift
//  Smart Spender
//
//  Created by Alex on 07.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    private var categories: [String] {
        get {
            let userCategories = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [String]
            return userCategories!
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "categories")
        }
    }
    
    private var categoryImages: [String] {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("categoryImages") as! [String]
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "categoryImages")
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar ()
    }
    
    private func setUpNavigationBar () {
        self.title = "Categories"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AddCategoryHeader.instanceFromNib()
        header.setUpButton ()
        header.delegate = self
        header.center = view.center
        return header
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CategoryCell
        cell.categoryName.text = categories[indexPath.row]
        cell.pictureView.image = UIImage(named: categoryImages[indexPath.row])
        cell.pictureView.layer.masksToBounds = true
        cell.pictureView.layer.cornerRadius = cell.pictureView.bounds.width/2
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categories.removeAtIndex(indexPath.row)
            categoryImages.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
}

extension CategoryTableViewController: AddCategoryDelegate {
    func addCategoryButtonPressed(controlHeader: AddCategoryHeader) {
        performSegueWithIdentifier("addCategoryVC", sender: nil)
    }
}

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var pictureView: UIImageView!
    
}
