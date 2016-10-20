//
//  HWImagesTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 10/19/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HWImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(imageCount: Int) {
        self.titleLabel.text = "共\(imageCount)张图片"
    }
}
