//
//  ProfileEditTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileEditTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!

    var imgURL: String?

    let placeholderImage = UIImage(named: "profile-placeholder")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGrayColor().CGColor

        if let imgURL = imgURL {
            profileImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        } else {
            profileImageView.image = placeholderImage
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
