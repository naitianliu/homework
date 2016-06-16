//
//  RecordItemTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 6/12/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class RecordItemTableViewCell: UITableViewCell {
    
    struct Constant {
        static let iconImageName = "record-icon-1"
    }
    
    let dateUtility = DateUtility()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.imageView?.image = UIImage(named: Constant.iconImageName)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurate(duration: NSTimeInterval, time: String) {
        let durationString = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(duration)
        self.textLabel?.text = durationString
        self.detailTextLabel?.text = time
    }

}
