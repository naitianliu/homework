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
    let classroomKeys = GlobalKeys.ClassroomKeys.self

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
        let read = dataJSON[self.updateKeys.read].boolValue
        if read {
            self.titleLabel.textColor = UIColor.grayColor()
        } else {
            self.titleLabel.textColor = UIColor.blackColor()
        }
        let type = dataJSON[self.updateKeys.type].stringValue
        switch type {
        case self.updateKeys.requests:
            self.setupRequestCell(dataJSON)
        case self.updateKeys.approvals:
            self.setupRequestCell(dataJSON)
        case self.updateKeys.homeworks:
            self.setupHomeworkCell(dataJSON)
        case self.updateKeys.submissions:
            self.setupSubmissionCell(dataJSON)
        case self.updateKeys.grades:
            self.setupGradeCell(dataJSON)
        case self.updateKeys.comments:
            self.setupCommentCell(dataJSON)
        default:
            break
        }
    }

    private func setupRequestCell(data: JSON) {
        let imgURL = data[self.updateKeys.imgURL].stringValue
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        self.iconImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }

    private func setupApprovalCell(data: JSON) {
        let imgURL = data[self.updateKeys.imgURL].stringValue
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        self.iconImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }

    private func setupHomeworkCell(data: JSON) {
        self.iconImageView.image = UIImage(named: "circle-icon-homework")
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString

    }

    private func setupSubmissionCell(data: JSON) {
        self.iconImageView.image = UIImage(named: "circle-icon-student")
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }

    private func setupGradeCell(data: JSON) {
        self.iconImageView.image = UIImage(named: "circle-icon-teacher")
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }

    private func setupCommentCell(data: JSON) {
        let title = data[self.updateKeys.title].stringValue
        let subtitle = data[self.updateKeys.subtitle].stringValue
        let timeString = data[self.updateKeys.timeString].stringValue
        let imgURL = data[self.updateKeys.imgURL].stringValue
        self.iconImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.timeLabel.text = timeString
    }
}
