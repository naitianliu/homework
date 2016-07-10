//
//  DescriptionTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String?, value: String?) {
        if let title = title {
            self.titleLabel.text = title
        }
        if let value = value {
            self.descriptionLabel.text = value
        } else {
            self.descriptionLabel.text = "未填写"
        }
    }

}
