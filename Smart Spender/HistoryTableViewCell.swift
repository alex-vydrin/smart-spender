//
//  HistoryTableViewCell.swift
//  Smart Spender
//
//  Created by Alex on 08.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
