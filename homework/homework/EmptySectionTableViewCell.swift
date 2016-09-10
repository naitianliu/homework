//
//  EmptySectionTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/8/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class EmptySectionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(descriptionText: String) {
        descriptionLabel.text = descriptionText
    }
    
}
