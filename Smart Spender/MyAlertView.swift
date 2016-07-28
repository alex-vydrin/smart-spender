//
//  MyAlertView.swift
//  Smart Spender
//
//  Created by Alex on 25.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class MyAlertView: UIView {

    private let label = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "recents"))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(text: String) {
        let width = UIScreen.mainScreen().bounds.width / 3 * 2
        
        label.frame = CGRectMake(10, 0, width - 10, CGFloat.max)
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = .Center
        label.sizeToFit()
        
        let height = label.frame.height + imageView.bounds.height * 1.5
        let x = (UIScreen.mainScreen().bounds.width - width) / 2
        let y = (UIScreen.mainScreen().bounds.height - height) / 2 - 50
        super.init(frame: CGRectMake(x, y, width, height))
        
        drawPosition()
        
        addSubview(imageView)
        addSubview(label)
        backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 12

    }
    
    private func drawPosition() {
        imageView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 3, imageView.bounds.height / 1.5)
        label.frame.origin.y = imageView.center.y + imageView.bounds.height / 1.5
    }

}
