//
//  DataBase.swift
//  Smart Spender
//
//  Created by Alex on 11.05.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class DataBase: NSObject {
    
    var trips = [MyTrip]()

    static let sharedInstance = DataBase()
    
}
