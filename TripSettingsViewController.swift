//
//  TripSettingsViewController.swift
//  Smart Spender
//
//  Created by Alex on 25.04.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class TripSettingsViewController: UIViewController {

    var titleName = String()
    var fromDate = NSDate()
    var toDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDateLabelToTitle ()
        navigationItem.hidesBackButton = true
        self.title = titleName
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDateLabelToTitle () {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if let navigationBar = self.navigationController?.navigationBar {
            
            let firstFrame = CGRect(x: navigationBar.frame.width/2 - 53, y: 16, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let firstLabel = UILabel(frame: firstFrame)
            firstLabel.text = "\(formatter.stringFromDate(fromDate)) - \(formatter.stringFromDate(toDate))"
            firstLabel.font = UIFont.init(name: "HelveticaNeue", size: 10.0)
            firstLabel.textColor = UIColor.whiteColor()
            navigationBar.addSubview(firstLabel)
        }
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
