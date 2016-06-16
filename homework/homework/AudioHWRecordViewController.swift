//
//  AudioHWRecordViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/10/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AudioHWRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    struct Constant {
        static let backButtonTitle = "返回"
        static let navItemTitle = "录音"
        static let recordLabelTitle = "开始录音"
        struct ImageName {
            static let recordButtonNormal = "record-button"
            static let recordButtonSelected = "recording-button"
            static let emptyDataSet = "headset"
        }
        struct Identifier {
            static let recordItemCell = "recordItemCell"
            static let playingRecordItemCell = "playingRecordItemCell"
        }
        struct EmptySet {
            static let title = "还没有任何录音"
            static let description = "尝试多次录音，选择最佳的录音提交。"
        }
    }
    
    let dateUtility = DateUtility()
    var timer: NSTimer?
    
    var originalNavbarShadowImage: UIImage?
    var originalTopItemTitle: String?
    
    var recording: Bool = false
    var playingRow: Int?
    
    var tableData = [[String: AnyObject]]()

    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var recorderHelper: RecorderHelper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        recorderHelper = RecorderHelper()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        originalNavbarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = Constant.navItemTitle
        self.recordView.backgroundColor = GlobalConstants.themeColor
        self.recordLabel.font = UIFont.boldSystemFontOfSize(20)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = originalNavbarShadowImage
        recorderHelper.closeRecordingSession()
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func startRecord() {
        playingRow = nil
        self.reloadTable()
        self.recorderHelper.startRecording { (success) in
            if success {
                self.recordButton.setBackgroundImage(UIImage(named: Constant.ImageName.recordButtonSelected), forState: .Normal)
                self.recording = true
                self.recordLabel.text = "00:00"
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.countTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    func stopRecord() {
        let currentTimeEpoch: Int = self.dateUtility.getCurrentEpochTime()
        let currentTimeString: String = self.dateUtility.convertEpochToHumanFriendlyString(currentTimeEpoch)
        self.recorderHelper.stopRecording { (recordItemData) in
            self.recording = false
            self.recordLabel.text = Constant.recordLabelTitle
            self.recordButton.setBackgroundImage(UIImage(named: Constant.ImageName.recordButtonNormal), forState: .Normal)
            let duration = recordItemData["duration"] as! NSTimeInterval
            let filename = recordItemData["filename"] as! String
            let uuid = recordItemData["uuid"] as! String
            let rowDict: [String: AnyObject] = [
                "duration": duration,
                "currentTime": currentTimeString,
                "recording": false,
                "filename": filename,
                "uuid": uuid
            ]
            self.tableData.append(rowDict)
            self.reloadTable()
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @IBAction func recordButtonToggle(sender: AnyObject) {
        if recording {
            stopRecord()
        } else {
            startRecord()
        }
    }
    
    func countTimer() {
        if recording {
            let currentEpoch: Int = self.dateUtility.getCurrentEpochTime()
            let startEpoch: Int = self.recorderHelper.startTimeEpoch
            let currentDuration: NSTimeInterval = NSTimeInterval(currentEpoch - startEpoch)
            let durationString: String = self.dateUtility.convertTimeIntervalToHumanFriendlyTime(currentDuration)
            self.recordLabel.text = durationString
        }
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let image = UIImage(named: Constant.ImageName.emptyDataSet)
        return image
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = Constant.EmptySet.title
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = Constant.EmptySet.description
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = NSTextAlignment.Center
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowDict = self.tableData[indexPath.row]
        let duration = rowDict["duration"] as! NSTimeInterval
        let currentTime = rowDict["currentTime"] as! String
        let filename = rowDict["filename"] as! String
        let uuid = rowDict["uuid"] as! String
        if indexPath.row == playingRow {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.Identifier.playingRecordItemCell) as! PlayingRecordItemTableViewCell
            cell.configurate(filename, duration: duration, submitOnClick: {
                // submit button event
                OSSHelper().uploadFile(filename, objectKey: uuid)
                }, playBackNextOnClick: { (type) in
                    if type == "next" {
                        
                    } else if type == "back" {
                        
                    }
            })
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constant.Identifier.recordItemCell) as! RecordItemTableViewCell
            cell.configurate(duration, time: currentTime)
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == playingRow {
            return 160
        } else {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if playingRow != indexPath.row {
            playingRow = indexPath.row
            self.reloadTable()
        }
    }
}
