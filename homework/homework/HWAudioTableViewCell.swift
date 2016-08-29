//
//  HWAudioTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HWAudioTableViewCell: UITableViewCell {

    struct kImageName {
        static let play = "record-icon-1"
        static let pause = "record-icon-2"
    }

    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(duration: String, status: String) {
        durationLabel.text = duration
        statusLabel.text = status
        switch status {
        case "pending":
            statusLabel.text = "未听"
            playImageView.image = UIImage(named: kImageName.play)
        case "working":
            statusLabel.text = "正在听"
            playImageView.image = UIImage(named: kImageName.pause)
        case "complete":
            statusLabel.text = "已听"
            playImageView.image = UIImage(named: kImageName.play)
        default:
            break
        }
    }
    
}
