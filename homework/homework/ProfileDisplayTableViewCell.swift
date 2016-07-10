//
//  ProfileDisplayTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ProfileDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    let placeholderImage = UIImage(named: "profile-placeholder")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = GlobalConstants.themeColor.CGColor

        if let imgURL = UserDefaultsHelper().getProfileImageURL() {
            profileImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        } else {
            profileImageView.image = placeholderImage
        }

        if let nickname = UserDefaultsHelper().getNickname() {
            nicknameLabel.text = nickname
        } else {
            nicknameLabel.text = "未取名"
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
