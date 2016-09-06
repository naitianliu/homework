//
//  UpdateTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    let updateKeys = GlobalKeys.UpdateKeys.self

    let placeholderImage = GlobalConstants.kProfileImagePlaceholder
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderIconImageView()
    }

    private func renderIconImageView() {
        let width = iconImageView.bounds.width
        iconImageView.layer.cornerRadius = width / 2
        iconImageView.layer.masksToBounds = true
    }

    func configurate(data: [String: AnyObject]) {
        let dataJSON = JSON(data)
        let type = dataJSON[self.updateKeys.type].stringValue
        switch type {
        case self.updateKeys.requests:
            self.setupRequestCell(dataJSON)
        default:
            break
        }
    }

    private func setupRequestCell(data: JSON) {
        let imgURL = data[self.updateKeys.imgURL].stringValue
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        let read = data[self.updateKeys.read].boolValue
        self.iconImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }
    
}
