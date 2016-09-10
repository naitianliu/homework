//
//  HWAudioTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import KDEAudioPlayer

class HWAudioTableViewCell: UITableViewCell, AudioPlayerDelegate {

    struct kImageName {
        static let play = "record-icon-1"
        static let pause = "record-icon-2"
    }

    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    var audioURL: String?

    var startEpoch: Int = 0

    var totalDuration: NSTimeInterval = 0

    let dateUtility = DateUtility()

    let player = AudioPlayer()

    typealias CompletePlayClosureType = () -> Void
    var completePlayBlock: CompletePlayClosureType!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        self.selectionStyle = .Gray

        self.player.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(data: [String: AnyObject], status: String, completePlay: CompletePlayClosureType) {
        self.completePlayBlock = completePlay
        let durationInt: Int = data[self.submissionKeys.duration] as! Int
        self.audioURL = data[self.submissionKeys.audioURL] as? String
        self.totalDuration = NSTimeInterval(durationInt)
        durationLabel.text = DateUtility().convertTimeIntervalToHumanFriendlyTime(self.totalDuration)
        statusLabel.text = status
        switch status {
        case submissionKeys.AudioStatus.pending:
            statusLabel.text = "未听"
            playImageView.image = UIImage(named: kImageName.play)
        case submissionKeys.AudioStatus.working:
            statusLabel.text = "正在播放"
            playImageView.image = UIImage(named: kImageName.pause)
            // play audio
            playFromStart()
        case submissionKeys.AudioStatus.complete:
            statusLabel.text = "已听"
            playImageView.image = UIImage(named: kImageName.play)
        case submissionKeys.AudioStatus.hidden:
            statusLabel.text = ""
            playImageView.image = UIImage(named: kImageName.play)
            player.stop()
        default:
            break
        }
    }

    func playFromStart() {
        player.stop()
        self.startEpoch = self.dateUtility.getCurrentEpochTime()
        if let audioURL = audioURL {
            print(audioURL)
            let url = NSURL(string: audioURL)
            let item = AudioItem(highQualitySoundURL: url, mediumQualitySoundURL: url, lowQualitySoundURL: url)
            player.playItem(item!)
        }
    }

    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        print(percentageRead)
        self.durationLabel.text = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(time)
    }

    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        switch to {
        case .Buffering:
            self.statusLabel.text = "正在缓冲"
            playImageView.image = UIImage(named: kImageName.pause)
        case .Playing:
            self.statusLabel.text = "正在播放"
            playImageView.image = UIImage(named: kImageName.pause)
        case .Paused:
            self.statusLabel.text = "已暂停"
            playImageView.image = UIImage(named: kImageName.play)
        case .Stopped:
            self.statusLabel.text = "播放完成"
            playImageView.image = UIImage(named: kImageName.play)
            self.completePlayBlock()
        case .WaitingForConnection:
            self.statusLabel.text = "正在连接"
            playImageView.image = UIImage(named: kImageName.pause)
        default:
            print("play error")
            break
        }
    }


    
}
