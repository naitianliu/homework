//
//  HWCommetTextTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HWCommetTextTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderProfileImageView()
    }

    private func renderProfileImageView() {
        let width = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true
    }

    func configurate(data: [String: AnyObject?]) {
        let profileImageURL: String = data["profileImgURL"]! as! String
        let name: String = data["name"]! as! String
        let time: String = data["time"]! as! String
        let content: String = data["content"]! as! String
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        nameLabel.text = name
        timeLabel.text = time
        contentLabel.text = content
    }
    
}
