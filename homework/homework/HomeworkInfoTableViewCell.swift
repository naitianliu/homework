//
//  HomeworkInfoTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class HomeworkInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: TTTAttributedLabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!

    private let placeholder = UIImage(named: "profile-placeholder")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        self.renderProfileImageView()
    }

    private func renderProfileImageView() {
        let width = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true
    }

    private func setupAttributedLabel(teacherName: String, homeworkType: String) {
        // redner label
        nameLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.textColor = UIColor.darkGrayColor()
        let linkAttributes = [
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(15),
            ]
        nameLabel.linkAttributes = linkAttributes
        let text = "\(teacherName) 布置了 \(homeworkType)"
        nameLabel.text = text
        let range = (text as NSString).rangeOfString(homeworkType)
        nameLabel.addLinkToURL(NSURL(string: homeworkType), withRange: range)

        
    }

    func configurate(data: [String: String]) {
        let teacherName: String = data["teacher"]!
        let homeworkType: String = data["homeworkType"]!
        let profileImageURL: String = data["profileImgURL"]!
        let time: String = data["time"]!
        let homeworkContent: String = data["homeworkContent"]!
        let dueDate: String = data["dueDate"]!
        self.setupAttributedLabel(teacherName, homeworkType: homeworkType)
        self.profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: placeholder)
        timeLabel.text = time
        contentLabel.text = homeworkContent
        dueDateLabel.text = "截止日期：\(dueDate)"
    }

}
