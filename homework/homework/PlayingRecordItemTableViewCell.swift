//
//  PlayingRecordItemTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 6/12/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class PlayingRecordItemTableViewCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var resumePauseButton: UIButton!
    
    typealias SubmitButtonEventClosureType = () -> Void
    typealias PlayBackNextEventClosureType = (type: String) -> Void
    
    var submitClosure: SubmitButtonEventClosureType?
    var playBackNextClosure: PlayBackNextEventClosureType?
    
    var startEpoch: Int = 0
    var durationTime: NSTimeInterval = 0
    var filename: String?
    
    let dateUtility = DateUtility()
    
    var playerHelper: PlayerHelper!
    
    var timer: NSTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurate(filename: String, duration: NSTimeInterval, submitOnClick: SubmitButtonEventClosureType, playBackNextOnClick: PlayBackNextEventClosureType) {
        let currentTimeString = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(0)
        let durationString = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(duration)
        self.durationTime = duration
        currentTimeLabel.text = currentTimeString
        totalTimeLabel.text = durationString
        self.submitClosure = submitOnClick
        self.playBackNextClosure = playBackNextOnClick
        self.filename = filename
        self.playFromStart()
    }
    
    func playFromStart() {
        self.playSlider.value = 0
        self.startEpoch = self.dateUtility.getCurrentEpochTime()
        if let filename = filename {
            playerHelper = PlayerHelper()
            playerHelper.startPlay(filename)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.countTimer), userInfo: nil, repeats: true)
        }
    }
    
    func countTimer() {
        let currentEpoch: Int = self.dateUtility.getCurrentEpochTime()
        let currentDuration: NSTimeInterval = NSTimeInterval(currentEpoch - startEpoch)
        if currentDuration <= self.durationTime {
            let currentDurationString: String = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(currentDuration)
            self.currentTimeLabel.text = currentDurationString
            let sliderValue = Float(currentDuration/self.durationTime)
            self.playSlider.value = sliderValue
        } else {
            timer?.invalidate()
            timer = nil
        }
        
    }

    @IBAction func submitButtonOnClick(sender: AnyObject) {
        if let submitClosure = submitClosure {
            submitClosure()
        }
    }
    
    @IBAction func playSliderValueChanged(sender: AnyObject) {
        
    }
    
    @IBAction func resumePauseButtonOnClick(sender: AnyObject) {
        
    }
    
    @IBAction func playNextButtonOnClick(sender: AnyObject) {
        if let playNextClosure = playBackNextClosure {
            playNextClosure(type: "next")
        }
    }
    
    @IBAction func playBackButtonOnClick(sender: AnyObject) {
        if let playBackClosure = playBackNextClosure {
            playBackClosure(type: "back")
        }
    }
    
}
