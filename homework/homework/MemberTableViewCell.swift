//
//  MemberTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!

    let profileImagePlaceholder = UIImage(named: "profile-placeholder")

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func renderProfileImageView() {
        let width = profileImageView.frame.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true
    }

    func configurate(nickname: String, imgURL: String, selected: Bool) {
        nicknameLabel.text = nickname
        profileImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: profileImagePlaceholder)
        if selected {
            self.accessoryType = .Checkmark
        } else {
            self.accessoryType = .None
        }
    }
    
}
