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

    let placeholderImage = UIImage(named: "profile-placeholder")

    override func awakeFromNib() {
        super.awakeFromNib()



    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Render containerView
        self.renderContainerView()
        // Render profileImageView
        self.renderProfileImageView(self.profileImageView1)
        self.renderProfileImageView(self.profileImageView2)
    }

    private func renderContainerView() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.masksToBounds = true
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
        // teachers profile image view
        let teacherCount = profileImgURLs.count
        if teacherCount == 0 {

        } else if teacherCount == 1 {
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImgURLs[0]), placeholderImage: placeholderImage)
            self.profileImageView2.hidden = true
            self.countLabel.hidden = true
        } else if teacherCount == 2 {
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImgURLs[0]), placeholderImage: placeholderImage)
            self.profileImageView2.sd_setImageWithURL(NSURL(string: profileImgURLs[1]), placeholderImage: placeholderImage)
            self.countLabel.hidden = true
        } else if teacherCount > 2 {
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImgURLs[0]), placeholderImage: placeholderImage)
            self.profileImageView2.sd_setImageWithURL(NSURL(string: profileImgURLs[1]), placeholderImage: placeholderImage)
            self.countLabel.text = "+\(teacherCount - 2)"
        } else {

        }
        // student number label
        self.studentNumberLabel.text = studentNumber

    }
}

