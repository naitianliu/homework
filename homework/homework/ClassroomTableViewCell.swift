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
    
    @IBOutlet weak var teacherNameLabel1: UILabel!
    @IBOutlet weak var teacherNameLabel2: UILabel!

    let placeholderImage = UIImage(named: "profile-placeholder")

    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self

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

    func configurate(rowData: [String: AnyObject]) {
        let classroomName: String = rowData[self.classroomKeys.classroomName]! as! String
        let schoolName: String? = rowData[self.classroomKeys.schoolName]! as? String
        let teacherProfiles: [[String: String]] = rowData[self.classroomKeys.teacherProfiles]! as! [[String: String]]
        let studentNumber: String = rowData[self.classroomKeys.studentNumber]! as! String
        self.classroomNameLabel.text = classroomName
        if let schoolName = schoolName {
            self.schoolNameLabel.text = schoolName
        } else {
            self.schoolNameLabel.text = "学校或机构未知"
        }
        // teachers profile image view
        let teacherCount = teacherProfiles.count
        if teacherCount == 0 {

        } else if teacherCount == 1 {
            let profileImageURL1: String = teacherProfiles[0][self.profileKeys.imgURL]!
            let nickname1: String = teacherProfiles[0][self.profileKeys.nickname]!
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImageURL1), placeholderImage: placeholderImage)
            self.teacherNameLabel1.text = nickname1
            self.profileImageView2.hidden = true
            self.teacherNameLabel2.hidden = true
            self.countLabel.hidden = true
        } else if teacherCount == 2 {
            let profileImageURL1: String = teacherProfiles[0][self.profileKeys.imgURL]!
            let nickname1: String = teacherProfiles[0][self.profileKeys.nickname]!
            let profileImageURL2: String = teacherProfiles[1][self.profileKeys.imgURL]!
            let nickname2: String = teacherProfiles[1][self.profileKeys.nickname]!
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImageURL1), placeholderImage: placeholderImage)
            self.profileImageView2.sd_setImageWithURL(NSURL(string: profileImageURL2), placeholderImage: placeholderImage)
            self.teacherNameLabel1.text = nickname1
            self.teacherNameLabel2.text = nickname2
            self.countLabel.hidden = true
        } else if teacherCount > 2 {
            let profileImageURL1: String = teacherProfiles[0][self.profileKeys.imgURL]!
            let nickname1: String = teacherProfiles[0][self.profileKeys.nickname]!
            let profileImageURL2: String = teacherProfiles[1][self.profileKeys.imgURL]!
            let nickname2: String = teacherProfiles[1][self.profileKeys.nickname]!
            self.profileImageView1.sd_setImageWithURL(NSURL(string: profileImageURL1), placeholderImage: placeholderImage)
            self.profileImageView2.sd_setImageWithURL(NSURL(string: profileImageURL2), placeholderImage: placeholderImage)
            self.teacherNameLabel1.text = nickname1
            self.teacherNameLabel2.text = nickname2
            self.countLabel.text = "+\(teacherCount - 2)"
        } else {

        }
        // student number label
        self.studentNumberLabel.text = studentNumber

    }
}

