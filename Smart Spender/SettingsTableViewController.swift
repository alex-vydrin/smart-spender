//
//  SettingsTableViewController.swift
//  Smart Spender
//
//  Created by Alex on 07.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar ()
    }


    @IBAction func doneButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setUpNavigationBar () {
        self.title = "Settings"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
