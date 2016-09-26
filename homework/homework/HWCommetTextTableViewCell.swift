//
//  HWCommetTextTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class HWCommetTextTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    let commentKeys = GlobalKeys.CommentKeys.self

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        self.selectionStyle = .None

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

    func configurate(data: [String: AnyObject]) {
        let infoJSON = JSON(data)
        let profileImageURL: String = infoJSON[self.commentKeys.authorImgURL].stringValue
        let name: String = infoJSON[self.commentKeys.authorName].stringValue
        let time: String = infoJSON[self.commentKeys.time].stringValue
        let content: String = infoJSON[self.commentKeys.text].stringValue
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        nameLabel.text = name
        timeLabel.text = time
        contentLabel.text = content
    }
    
}
