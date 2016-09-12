//
//  HWCommentTextAudioTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class HWCommentTextAudioTableViewCell: UITableViewCell {

    struct kImageName {
        static let play = "record-icon-1"
        static let pause = "record-icon-2"
    }

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var audioView: UIView!

    let commentKeys = GlobalKeys.CommentKeys.self

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderProfileImageView()
        self.renderAudioView()
    }

    private func renderProfileImageView() {
        let width = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.layer.masksToBounds = true
    }

    private func renderAudioView() {
        audioView.layer.borderColor = UIColor.lightGrayColor().CGColor
        audioView.layer.borderWidth = 1
        audioView.layer.cornerRadius = 5
    }

    func configurate(data: [String: AnyObject]) {
        let dataJSON = JSON(data)
        let profileImageURL: String = dataJSON[self.commentKeys.authorImgURL].stringValue
        let name: String = dataJSON[self.commentKeys.authorName].stringValue
        let time: String = dataJSON[self.commentKeys.time].stringValue
        let content: String = dataJSON[self.commentKeys.text].stringValue
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        nameLabel.text = name
        timeLabel.text = time
        contentLabel.text = content
        // audio view
        let audioInfoJSON = dataJSON[self.commentKeys.audioInfo]
        let durationInt: Int = audioInfoJSON[self.commentKeys.duration].intValue
        let durationNSTimeInterval = NSTimeInterval(durationInt)
        durationLabel.text = DateUtility().convertTimeIntervalToHumanFriendlyTime(durationNSTimeInterval)
        playImageView.image = UIImage(named: kImageName.play)
    }
    
    
}
