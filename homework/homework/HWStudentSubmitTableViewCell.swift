//
//  HWStudentSubmitTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HWStudentSubmitTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

    private func setupScoreLabel(score: String?) {
        if let score = score {
            scoreLabel.font = UIFont.boldSystemFontOfSize(25)
            scoreLabel.textColor = UIColor.redColor()
            scoreLabel.text = score
        } else {
            scoreLabel.layer.cornerRadius = 15
            scoreLabel.layer.borderColor = UIColor.grayColor().CGColor
            scoreLabel.font = UIFont.boldSystemFontOfSize(13)
            scoreLabel.textColor = UIColor.grayColor()
            scoreLabel.text = "未批改"
        }
    }

    func configurate(data: [String: String?]) {
        let profileImageURL: String = data["profileImgURL"]!!
        let name: String = data["name"]!!
        let time: String = data["time"]!!
        let score: String? = data["score"]!
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        nameLabel.text = name
        timeLabel.text = time
        self.setupScoreLabel(score)
    }

}
