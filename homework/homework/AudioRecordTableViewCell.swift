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

    override func awakeFromNib() {
        super.awakeFromNib()

        self.accessoryType = .DisclosureIndicator
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(audioDuration: NSTimeInterval?) {
        if let audioDuration = audioDuration {
            self.iconImageView.image = playImage
            self.contentLabel.text = DateUtility().convertTimeIntervalToHumanFriendlyTime(audioDuration)
        } else {
            self.iconImageView.image = microphoneImage
            self.contentLabel.text = "添加语音内容"
        }
    }
    
}
