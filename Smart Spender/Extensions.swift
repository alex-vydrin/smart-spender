//
//  Extensions.swift
//  Smart Spender
//
//  Created by Alex on 01.08.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
        func playImplicitBounceAnimation() {
            
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            bounceAnimation.duration = NSTimeInterval(0.5)
            bounceAnimation.calculationMode = kCAAnimationCubic
            
            layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
        }
}

extension IntegerType {
    var stringWithSepator: String {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .DecimalStyle
        return formatter.stringFromNumber(hashValue) ?? ""
    }
}
