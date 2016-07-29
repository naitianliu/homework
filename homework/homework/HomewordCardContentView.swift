//
//  HomewordCardContentView.swift
//  homework
//
//  Created by Liu, Naitian on 7/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SDWebImage

class HomewordCardContentView: UIView {

    @IBOutlet weak var attributedLabel: TTTAttributedLabel!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!

    var data: [String: AnyObject]!

    func configurate(data: [String: AnyObject]) {
        self.data = data

        self.setupProfileImageView()
        self.setupAttributedLabel()
        self.setupTimeLabel()
        self.setupContentLabel()
        self.setupDueDateLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderProfileImageView()

    }

    private func renderProfileImageView() {
        let width = profileImageView.frame.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true

    }

    private func setupProfileImageView() {
        let placeholder = UIImage(named: "profile-placeholder")
        var url: String = ""
        if let value = self.data["profileImgURL"] {
            url = value as! String
            self.profileImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholder)
        }
    }

    private func setupAttributedLabel() {
        let teacher = self.data["teacher"] as! String
        let homeworkType = self.data["homeworkType"] as! String
        // redner label
        attributedLabel.font = UIFont.systemFontOfSize(15)
        attributedLabel.textColor = UIColor.darkGrayColor()
        let linkAttributes = [
            NSForegroundColorAttributeName: UIColor.blueColor(),
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(15),
        ]
        attributedLabel.linkAttributes = linkAttributes
        let text = "\(teacher) 布置了 \(homeworkType)"
        attributedLabel.text = text
        let range = (text as NSString).rangeOfString(homeworkType)
        self.attributedLabel.addLinkToURL(NSURL(string: homeworkType), withRange: range)


    }

    private func setupTimeLabel() {
        let time = self.data["time"] as! String
        self.timeLabel.text = time
    }

    private func setupContentLabel() {
        let homeworkContent = self.data["homeworkContent"] as! String
        self.contentLabel.text = homeworkContent
    }

    private func setupDueDateLabel() {
        let dueDate = self.data["dueDate"] as! String
        self.dueDateLabel.text = dueDate

    }

}