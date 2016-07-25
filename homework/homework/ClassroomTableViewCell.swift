//
//  ClassroomTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage

class ClassroomTableViewCell: UITableViewCell {

    @IBOutlet weak var classroomNameLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var profileImageView2: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Render containerView
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.masksToBounds = true
        // Render profileImageView
        self.renderProfileImageView(self.profileImageView1)
        self.renderProfileImageView(self.profileImageView2)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func renderProfileImageView(imageView: UIImageView) {
        let height = imageView.frame.width
        imageView.layer.cornerRadius = height / 2
        imageView.layer.masksToBounds = true
    }

    func configurate(classroomName: String, schoolName: String?, profileImgURLs: [String], studentNumber: String?) {
        self.classroomNameLabel.text = classroomName
        if let schoolName = schoolName {
            self.schoolNameLabel.text = schoolName
        } else {
            self.schoolNameLabel.text = "学校或机构未知"
        }
        let teacherCount = profileImgURLs.count
        if teacherCount == 0 {

        } else if teacherCount == 1 {

        } else if teacherCount == 2 {

        } else if teacherCount > 2 {

        } else {

        }
    }
}

