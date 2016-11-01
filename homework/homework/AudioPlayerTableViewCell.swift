//
//  AudioPlayerTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 10/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import KDEAudioPlayer
import ESTMusicIndicator

class AudioPlayerTableViewCell: UITableViewCell, AudioPlayerDelegate {

    let thumbImageNormal = UIImage(named: "thumb-normal")

    @IBOutlet weak var playStatusView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var resumePauseButton: UIButton!
    @IBOutlet weak var resumePauseLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var slider: UISlider!

    var indicator: ESTMusicIndicatorView!
    var activityIndicator: UIActivityIndicatorView!

    let dateUtility = DateUtility()

    var currentPlayingTime: NSTimeInterval = 0

    let player = AudioPlayer()

    var audioURL: String?

    var totalTime: NSTimeInterval = 0

    var playing: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        self.renderMusicIndicator()
        self.renderActivityIndicator()
        self.renderSlider()

        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None

        self.player.delegate = self

        self.playing = false

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func renderMusicIndicator() {
        self.indicator = ESTMusicIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.indicator.tintColor = GlobalConstants.themeColor
        self.playStatusView.addSubview(indicator)
    }

    private func renderActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        self.playStatusView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }

    private func renderSlider() {
        self.slider.value = 0
        self.slider.setThumbImage(thumbImageNormal, forState: .Normal)
    }

    func configure(title: String?, audioURL: String?, duration: NSTimeInterval, play: Bool) {
        if let title = title {
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = "未命名录音"
        }
        self.progressTimeLabel.text = "00:00"
        self.totalTime = duration
        self.totalTimeLabel.text = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(duration)
        self.audioURL = audioURL
        if play {
            self.restart()
        }
    }

    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        self.currentPlayingTime = time
        self.progressTimeLabel.text = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(time)
        let sliderValue = Float(percentageRead / 100)
        self.slider.value = sliderValue
    }

    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        switch to {
        case .Buffering:
            self.buffer()
        case .Playing:
            self.resume()
        case .Paused:
            self.pause()
        case .Stopped:
            self.stop()
        case .WaitingForConnection:
            self.connect()
        default:
            self.error()
        }
    }

    private func restart() {
        self.currentPlayingTime = 0
        player.stop()
        self.play()

    }

    private func play() {
        if let audioURL = audioURL {
            let url = NSURL(string: audioURL)
            let item = AudioItem(highQualitySoundURL: url, mediumQualitySoundURL: url, lowQualitySoundURL: url)
            player.playItem(item!)
        }
    }

    private func resume() {
        self.playing = true
        self.statusLabel.text = "正在播放"
        self.indicator.state = .ESTMusicIndicatorViewStatePlaying
        self.indicator.hidden = false
        self.activityIndicator.hidden = true
    }

    private func pause() {
        self.playing = false
        self.statusLabel.text = "已暂停"
        self.indicator.state = .ESTMusicIndicatorViewStatePaused
        self.indicator.hidden = false
        self.activityIndicator.hidden = true
    }

    private func buffer() {
        self.playing = false
        self.statusLabel.text = "正在缓冲"
        self.indicator.hidden = true
        self.activityIndicator.hidden = false
    }

    private func connect() {
        self.playing = false
        self.statusLabel.text = "正在连接"
        self.indicator.hidden = true
        self.activityIndicator.hidden = false
    }

    private func stop() {
        self.playing = false
        self.statusLabel.text = "已播完"
        self.indicator.state = .ESTMusicIndicatorViewStateStopped
        self.indicator.hidden = false
        self.activityIndicator.hidden = true
    }

    private func error() {
        self.playing = false
        self.statusLabel.text = "连接错误"
        self.indicator.state = .ESTMusicIndicatorViewStateStopped
        self.indicator.hidden = false
        self.activityIndicator.hidden = true
    }

    @IBAction func restartButtonOnClick(sender: AnyObject) {

    }

    @IBAction func exitButtonOnClick(sender: AnyObject) {

    }

    @IBAction func resumePauseButtonOnClick(sender: AnyObject) {
        if self.playing {
            self.player.pause()
            self.resumePauseButton.setBackgroundImage(UIImage(named: "record-icon-1"), forState: .Normal)
            self.resumePauseLabel.text = "播放"
        } else {
            self.player.resume()
            self.resumePauseButton.setBackgroundImage(UIImage(named: "record-icon-2"), forState: .Normal)
            self.resumePauseLabel.text = "暂停"
        }
    }

    @IBAction func playBackwardButtonOnClick(sender: AnyObject) {

    }

    @IBAction func playForwardButtonOnClick(sender: AnyObject) {

    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        let value = self.slider.value
        self.currentPlayingTime = Double(value) * self.totalTime
        self.progressTimeLabel.text = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(self.currentPlayingTime)
    }
    
    @IBAction func sliderDragStarted(sender: AnyObject) {
        print("started")
        if self.playing {
            self.player.pause()
        }
    }

    @IBAction func sliderDragReleased(sender: AnyObject) {
        print("released")
        if self.playing {
            self.player.seekToTime(self.currentPlayingTime)
        } else {
            self.player.seekToTime(self.currentPlayingTime)
            self.play()
        }

    }
    

    
}
