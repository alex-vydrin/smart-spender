//
//  AddCategoryHeader.swift
//  Smart Spender
//
//  Created by Alex on 12.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategoryButtonPressed (controlHeader: AddCategoryHeader)
}

class AddCategoryHeader: UITableViewHeaderFooterView {

    var delegate: AddCategoryDelegate?
    
    @IBOutlet var button: UIButton!
    
    class func instanceFromNib() -> AddCategoryHeader {
        return UINib(nibName: "AddCategoryHeader", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddCategoryHeader
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    @IBAction func btnPressed(sender: UIButton) {
        button.backgroundColor = UIColor(colorLiteralRed: 133/255, green: 74/255, blue: 196/255, alpha: 1)
    }
    
    @IBAction func btnReleased(sender: UIButton) {
        button.backgroundColor = UIColor.clearColor()
    }
    
    
    func addNewCategory() {
        delegate?.addCategoryButtonPressed(self)
    }
    
    func setUpButton () {
        button.addTarget(self, action: #selector(AddCategoryHeader.addNewCategory), forControlEvents: .TouchUpInside)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(colorLiteralRed: 133/255, green: 74/255, blue: 196/255, alpha: 1).CGColor
        button.layer.cornerRadius = button.bounds.height / 2
    }

}
