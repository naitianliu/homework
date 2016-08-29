//
//  HWCommentTextAudioTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

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

    func configurate(data: [String: AnyObject?]) {
        let profileImageURL: String = data["profileImgURL"]! as! String
        let name: String = data["name"]! as! String
        let time: String = data["time"]! as! String
        let content: String = data["content"]! as! String
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageURL), placeholderImage: GlobalConstants.kProfileImagePlaceholder)
        nameLabel.text = name
        timeLabel.text = time
        contentLabel.text = content
        // audio view
        let audioData: [String: AnyObject] = data["audio"] as! [String: AnyObject]
        let duration: String = audioData["duration"]! as! String
        durationLabel.text = duration
        let playing: Bool = audioData["playing"]! as! Bool
        if playing {
            playImageView.image = UIImage(named: kImageName.pause)
        } else {
            playImageView.image = UIImage(named: kImageName.play)
        }
    }
    
    
}
