//
//  StudentHomeworkDetailViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SVPullToRefresh
import SKPhotoBrowser


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

    var homeworkAudioList = [[String: AnyObject]]()
    var homeworkImageURLList = [String]()

    var homeworkPlayingIndex: Int = -1
    var homeworkPlayingStatus: String = ""

    var currentPlayingIndex: (Int, Int) = (-1, -1)
    var shouldPlay: Bool = true

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

        self.setupPullToRefresh()



        self.reloadTable()

        self.tabBarController?.tabBar.hidden = true

        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.triggerPullToRefresh()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.commentPlayingIndex = -1
        self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
        self.shouldPlay = false
        self.tableView.reloadData()
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
        tableView.registerNib(UINib(nibName: "HWImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "HWImagesTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommetTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommetTextTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommentTextAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommentTextAudioTableViewCell")
        tableView.registerNib(UINib(nibName: "EmptySectionTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptySectionTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioPlayerTableViewCell")

    }

    func reloadTable() {
        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)
        if let audioList = homeworkData[self.submissionKeys.audioList] {
            self.homeworkAudioList = audioList as! [[String: AnyObject]]
        }
        if let imageURLs = homeworkData[self.submissionKeys.imageURLList] {
            self.homeworkImageURLList = imageURLs as! [String]
        }
        self.submissionUUID = self.submissionViewModel.getSubmissionUUIDByHomeworkUUID(self.homeworkUUID)
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
            var imageCount: Int = 0
            if self.homeworkImageURLList.count > 0 {
                imageCount = 1
            }
            return 1 + self.homeworkAudioList.count + imageCount
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
                cell.configurate(homeworkData)
                return cell
            } else if indexPath.row < self.homeworkAudioList.count + 1 {
                let rowDict = self.homeworkAudioList[indexPath.row - 1]
                let duration: NSTimeInterval = rowDict[self.submissionKeys.duration] as! NSTimeInterval
                let audioURL = rowDict[self.submissionKeys.audioURL] as? String
                let recordName = rowDict[self.submissionKeys.recordName] as? String
                if self.currentPlayingIndex == (indexPath.section, indexPath.row) {
                    let cell = tableView.dequeueReusableCellWithIdentifier("AudioPlayerTableViewCell") as! AudioPlayerTableViewCell
                    cell.configure(nil, audioURL: audioURL, duration: duration, play: self.shouldPlay, exitPlayerBlock: {
                        self.currentPlayingIndex = (-1, -1)
                        self.tableView.reloadData()
                    })
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
                    cell.configurate(duration, recordName: recordName)
                    return cell
                }
            } else if indexPath.row == self.homeworkAudioList.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWImagesTableViewCell") as! HWImagesTableViewCell
                cell.configurate(self.homeworkImageURLList.count)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if let submissionData = self.submissionData {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("HWStudentSubmitTableViewCell") as! HWStudentSubmitTableViewCell
                    cell.configurate(submissionData)
                    return cell
                } else {
                    let rowDict = self.submissionArray[indexPath.row - 1]
                    let submissionType = rowDict[self.submissionKeys.submissionType] as! String
                    if submissionType == "audio" {
                        let duration: NSTimeInterval = rowDict[self.submissionKeys.duration] as! NSTimeInterval
                        let audioURL = rowDict[self.submissionKeys.audioURL] as? String
                        let recordName = rowDict[self.submissionKeys.recordName] as? String
                        print(self.currentPlayingIndex)
                        if self.currentPlayingIndex == (indexPath.section, indexPath.row) {
                            let cell = tableView.dequeueReusableCellWithIdentifier("AudioPlayerTableViewCell") as! AudioPlayerTableViewCell
                            cell.configure(nil, audioURL: audioURL, duration: duration, play: self.shouldPlay, exitPlayerBlock: {
                                self.currentPlayingIndex = (-1, -1)
                                self.tableView.reloadData()
                            })
                            return cell
                        } else {
                            let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
                            cell.configurate(duration, recordName: recordName)
                            return cell
                        }
                    } else if submissionType == "images" {
                        let imageURLs: [String] = rowDict[self.submissionKeys.imageURLList] as! [String]
                        let cell = tableView.dequeueReusableCellWithIdentifier("HWImagesTableViewCell") as! HWImagesTableViewCell
                        cell.configurate(imageURLs.count)
                        return cell
                    } else {
                        return UITableViewCell()
                    }
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
            let rowDict = self.submissionArray[indexPath.row - 1]
            let submissionType = rowDict[self.submissionKeys.submissionType] as! String
            if submissionType == "audio" {
                self.commentPlayingIndex = -1
                self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
                if self.currentPlayingIndex != (indexPath.section, indexPath.row) {
                    self.currentPlayingIndex = (indexPath.section, indexPath.row)
                    self.shouldPlay = true
                    tableView.reloadData()
                }
            } else if submissionType == "images" {
                let imageURLs: [String] = rowDict[self.submissionKeys.imageURLList] as! [String]
                self.showPhotoBrowser(imageURLs)
            }
        } else if indexPath.section == 2 {
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
            self.shouldPlay = false
            tableView.reloadData()
        } else if indexPath.section == 0 {
            self.commentPlayingIndex = -1
            self.commentPlayingStatus = self.submissionKeys.AudioStatus.hidden
            if indexPath.row > 0 && indexPath.row < self.homeworkAudioList.count + 1 {
                if self.currentPlayingIndex != (indexPath.section, indexPath.row) {
                    self.currentPlayingIndex = (indexPath.section, indexPath.row)
                    self.shouldPlay = true
                    tableView.reloadData()
                }
            } else if indexPath.row == self.homeworkAudioList.count + 1 {
                self.showPhotoBrowser(self.homeworkImageURLList)
            }
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
        self.showPrepareSubmissionNC()
    }

    func commentButtonOnClick(sender: AnyObject) {
        self.showHomeworkCommentVC()
    }

    private func showPrepareSubmissionNC() {
        if self.submissionUUID == nil {
            let prepareSubmissionVC = PrepareSubmissionViewController(nibName: "PrepareSubmissionViewController", bundle: nil)
            prepareSubmissionVC.homeworkUUID = self.homeworkUUID
            prepareSubmissionVC.completePrepareSubmissionBlockSetter { (info) in
                APIHomeworkSubmit(vc: self).run(self.homeworkUUID, info: info)
            }
            let navigationController = UINavigationController(rootViewController: prepareSubmissionVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        } else {
            AlertHelper(viewController: self).showPromptAlertView("作业已提交，请勿重复提交")
        }
    }

    private func showAudioWHRecordVC() {
        if self.submissionUUID == nil {
            let audioHWRecordVC = AudioHWRecordViewController(nibName: "AudioHWRecordViewController", bundle: nil)
            audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL, recordName) in
                let durationInt = Int(duration)
                var audioList: [[String: AnyObject]] = []
                let audioInfo: [String: AnyObject] = [
                    self.submissionKeys.duration: durationInt,
                    self.submissionKeys.audioURL: audioURL,
                    self.submissionKeys.recordName: recordName
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

    private func showHomeworkCommentVC() {
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

    private func showPhotoBrowser(imageURLs: [String]) {
        var photos = [SKPhoto]()
        for url in imageURLs {
            let photo = SKPhoto.photoWithImageURL(url)
            photos.append(photo)
        }
        // initiate browser
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(0)
        presentViewController(browser, animated: true, completion: nil)
    }

    private func setupPullToRefresh() {
        tableView.addPullToRefreshWithActionHandler {
            if let submissionUUID = self.submissionUUID {
                APIHomeworkGetSubmissionInfo(vc: self).run(submissionUUID, homeworkUUID: nil)
            } else {
                APIHomeworkGetSubmissionInfo(vc: self).run(nil, homeworkUUID: self.homeworkUUID)
                // self.tableView.pullToRefreshView.stopAnimating()
            }
        }
        tableView.pullToRefreshView.setTitle("下拉刷新", forState: UInt(SVPullToRefreshStateStopped))
        tableView.pullToRefreshView.setTitle("释放刷新", forState: UInt(SVPullToRefreshStateTriggered))
        tableView.pullToRefreshView.setTitle("正在载入...", forState: UInt(SVPullToRefreshStateLoading))
    }

}
