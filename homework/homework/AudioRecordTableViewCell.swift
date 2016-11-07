//
//  AudioRecordTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class AudioRecordTableViewCell: UITableViewCell {

    let microphoneImage = UIImage(named: "button-microphone")
    let playImage = UIImage(named: "record-icon-1")

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.accessoryType = .DisclosureIndicator

        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(audioDuration: NSTimeInterval?, recordName: String?) {
        if let audioDuration = audioDuration {
            self.iconImageView.image = playImage
            self.subtitleLabel.text = DateUtility().convertTimeIntervalToHumanFriendlyTime(audioDuration)
            if let recordName = recordName {
                self.contentLabel.text = recordName
            } else {
                self.contentLabel.text = "未命名录音"
            }
        } else {
            self.iconImageView.image = microphoneImage
            self.contentLabel.text = "添加语音内容"
            self.subtitleLabel.text = nil
        }
    }
    
}
