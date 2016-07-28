//
//  AddNewCategoryViewController.swift
//  Smart Spender
//
//  Created by Alex on 27.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class AddNewCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar ()
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
    }

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupNavBar () {
        navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
}
