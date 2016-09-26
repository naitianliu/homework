//
//  StudentHomeworkDetailViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class StudentHomeworkDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionView: UIView!

    var homeworkUUID: String!
    var homeworkData: [String: AnyObject]!

    var submissionUUID: String?
    var submissionData: [String: AnyObject?]?
    var submissionArray: [[String: AnyObject]] = []
    var comments: [[String: AnyObject]] = []

    var playingIndex: Int = -1
    var playingStatus: String = ""

    var commentPlayingIndex: Int = -1
    var commentPlayingStatus: String = ""

    var navbarTitle: String?

    let homeworkViewModel = HomeworkViewModel()
    let submissionViewModel = SubmissionViewModel()
    let commentViewModel = CommentViewModel()

    let submissionKeys = GlobalKeys.SubmissionKeys.self
    let commentKeys = GlobalKeys.CommentKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()

        self.setupActionView()
        self.renderActionView()

        if let navbarTitle = navbarTitle {
            self.navigationItem.title = navbarTitle
        } else {
            self.navigationItem.title = "我的作业"
        }

        self.submissionUUID = self.submissionViewModel.getSubmissionUUIDByHomeworkUUID(self.homeworkUUID)

        self.reloadTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")
        tableView.registerNib(UINib(nibName: "HWStudentSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "HWStudentSubmitTableViewCell")
        tableView.registerNib(UINib(nibName: "HWAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "HWAudioTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommetTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommetTextTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommentTextAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommentTextAudioTableViewCell")
        tableView.registerNib(UINib(nibName: "EmptySectionTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptySectionTableViewCell")

    }

    func reloadTable() {
        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)
        if let submissionUUID = submissionUUID, let submissionTup = self.submissionViewModel.getSubmissionData(submissionUUID) {
            self.submissionData = submissionTup.0
            self.submissionArray = submissionTup.1
            self.comments = self.commentViewModel.getCommentsList(submissionUUID)
        }
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.submissionArray.count + 1
        case 2:
            if self.comments.count == 0 {
                return 1
            } else {
                return self.comments.count
            }
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
            cell.selectionStyle = .None
            cell.configurate(homeworkData)
            return cell
        case 1:
            if let submissionData = self.submissionData {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HWStudentSubmitTableViewCell") as! HWStudentSubmitTableViewCell
                    cell.configurate(submissionData)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HWAudioTableViewCell") as! HWAudioTableViewCell
                    let currentIndex = indexPath.row - 1
                    var status = self.submissionKeys.AudioStatus.hidden
                    if currentIndex == self.playingIndex {
                        status = self.playingStatus
                    }
                    let rowDict = self.submissionArray[indexPath.row - 1]
                    cell.configurate(rowDict, status: status, completePlay: { 
                        self.playingIndex = -1
                        self.playingStatus = self.submissionKeys.AudioStatus.hidden
                    })
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("EmptySectionTableViewCell") as! EmptySectionTableViewCell
                cell.configurate("目前还未提交作业")
                return cell
            }
        case 2:
            if comments.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("EmptySectionTableViewCell") as! EmptySectionTableViewCell
                cell.configurate("还没有任何评论")
                return cell
            } else {
                let rowDict = comments[indexPath.row]
                let hasAudio = rowDict[self.commentKeys.hasAudio] as! Bool
                if hasAudio {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HWCommentTextAudioTableViewCell") as! HWCommentTextAudioTableViewCell
                    let currentIndex = indexPath.row
                    var status = self.submissionKeys.AudioStatus.hidden
                    if currentIndex == self.commentPlayingIndex {
                        status = self.commentPlayingStatus
                    }
                    cell.configurate(rowDict, status: status, completePlay: {
                        self.commentPlayingIndex = -1
                        self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
                    })
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HWCommetTextTableViewCell") as! HWCommetTextTableViewCell
                    cell.configurate(rowDict)
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row > 0 {
            self.commentPlayingIndex = -1
            self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
            if self.playingIndex == indexPath.row - 1 {
                self.playingStatus = self.submissionKeys.AudioStatus.hidden
                self.playingIndex = -1
            } else if self.playingStatus == self.submissionKeys.AudioStatus.working {
                self.playingStatus = self.submissionKeys.AudioStatus.hidden
                self.playingIndex = indexPath.row - 1
            } else {
                self.playingStatus = self.submissionKeys.AudioStatus.working
                self.playingIndex = indexPath.row - 1
            }
            tableView.reloadData()
        } else if indexPath.section == 2 {
            self.playingIndex = -1
            self.playingStatus = self.submissionKeys.AudioStatus.hidden
            if self.commentPlayingIndex == indexPath.row {
                self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
                self.commentPlayingIndex = -1
            } else if self.commentPlayingStatus == self.submissionKeys.AudioStatus.working {
                self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
                self.commentPlayingIndex = indexPath.row
            } else {
                self.commentPlayingStatus = self.submissionKeys.AudioStatus.working
                self.commentPlayingIndex = indexPath.row
            }
            tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 20
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "我提交的作业"
        case 2:
            return "全部评论"
        default:
            return nil
        }
    }

    private func setupActionView() {
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let kRadio: CGFloat = 1
        let kOffsetX: CGFloat = 80
        let kOffsetY: CGFloat = 10
        let kBtnWidth: CGFloat = 60 * kRadio
        let kBtnHeight: CGFloat = 60
        let gap: CGFloat = screenWidth - kOffsetX * 2 - kBtnWidth * 2
        // init grade button
        let submitButton = UIButton(frame: CGRect(x: kOffsetX, y: kOffsetY, width: kBtnWidth, height: kBtnHeight))
        submitButton.setBackgroundImage(UIImage(named: "button-submit-bg"), forState: .Normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonOnClick), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(submitButton)
        // init comment button
        let commentButton = UIButton(frame: CGRect(x: kOffsetX + kBtnWidth + gap, y: kOffsetY, width: kBtnWidth, height: kBtnHeight))
        commentButton.setBackgroundImage(UIImage(named: "button-comment-bg"), forState: .Normal)
        commentButton.addTarget(self, action: #selector(self.commentButtonOnClick), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(commentButton)
    }

    private func renderActionView() {
        actionView.backgroundColor = UIColor.whiteColor()
        actionView.layer.shadowOffset = CGSize(width: 2, height: 3)
        actionView.layer.shadowColor = UIColor.grayColor().CGColor
        actionView.layer.shadowRadius = 3
        actionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        actionView.layer.borderWidth = 1
    }

    func submitButtonOnClick(sender: AnyObject) {
        self.showAudioWHRecordVC()
    }

    func commentButtonOnClick(sender: AnyObject) {
        self.showHomeworkCommentVC()
    }

    private func showAudioWHRecordVC() {
        if self.submissionUUID == nil {
            let audioHWRecordVC = AudioHWRecordViewController(nibName: "AudioHWRecordViewController", bundle: nil)
            audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL) in
                let durationInt = Int(duration)
                var audioList: [[String: AnyObject]] = []
                let audioInfo: [String: AnyObject] = [
                    self.submissionKeys.duration: durationInt,
                    self.submissionKeys.audioURL: audioURL
                ]
                audioList.append(audioInfo)
                let info: [String: AnyObject] = [
                    self.submissionKeys.audioList: audioList
                ]
                APIHomeworkSubmit(vc: self).run(self.homeworkUUID, info: info)
            }
            self.navigationController?.pushViewController(audioHWRecordVC, animated: true)
        } else {
            AlertHelper(viewController: self).showPromptAlertView("作业已提交，请勿重复提交")
        }

    }

    func showHomeworkCommentVC() {
        if let submissionUUID = submissionUUID {
            let homeworkCommentVC = HomeworkCommentViewController(nibName: "HomeworkCommentViewController", bundle: nil)
            homeworkCommentVC.submissionUUID = submissionUUID
            let commentNC = UINavigationController(rootViewController: homeworkCommentVC)
            commentNC.modalTransitionStyle = .CoverVertical
            self.presentViewController(commentNC, animated: true, completion: nil)
        } else {
            AlertHelper(viewController: self).showPromptAlertView("必须先提交作业才能评论")
        }
    }


}
