//
//  HWCommentTextAudioTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON
import KDEAudioPlayer

class HWCommentTextAudioTableViewCell: UITableViewCell, AudioPlayerDelegate {

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
    let submissionKeys = GlobalKeys.SubmissionKeys.self

    var audioURL: String?
    var startEpoch: Int = 0
    var totalDuration: NSTimeInterval = 0
    let player = AudioPlayer()

    typealias CompletePlayClosureType = () -> Void
    var completePlayBlock: CompletePlayClosureType!

    let dateUtility = DateUtility()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);

        self.player.delegate = self

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

    func configurate(data: [String: AnyObject], status: String, completePlay: CompletePlayClosureType) {
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
        self.audioURL = audioInfoJSON[self.commentKeys.audioURL].string
        let durationInt: Int = audioInfoJSON[self.commentKeys.duration].intValue
        self.totalDuration = NSTimeInterval(durationInt)
        durationLabel.text = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(self.totalDuration)
        playImageView.image = UIImage(named: kImageName.play)
        //
        switch status {
        case submissionKeys.AudioStatus.pending:
            playImageView.image = UIImage(named: kImageName.play)
        case submissionKeys.AudioStatus.working:
            playImageView.image = UIImage(named: kImageName.pause)
            // play audio
            playFromStart()
        case submissionKeys.AudioStatus.complete:
            playImageView.image = UIImage(named: kImageName.play)
        case submissionKeys.AudioStatus.hidden:
            playImageView.image = UIImage(named: kImageName.play)
            player.stop()
        default:
            break
        }
        self.completePlayBlock = completePlay
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
            self.durationLabel.text = "正在缓冲"
            playImageView.image = UIImage(named: kImageName.pause)
        case .Playing:
            playImageView.image = UIImage(named: kImageName.pause)
        case .Paused:
            playImageView.image = UIImage(named: kImageName.play)
        case .Stopped:
            playImageView.image = UIImage(named: kImageName.play)
        case .WaitingForConnection:
            self.durationLabel.text = "正在连接"
            playImageView.image = UIImage(named: kImageName.pause)
        default:
            print("play error")
            break
        }
    }
    
}
