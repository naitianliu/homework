//
//  HomeworkDetailViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class HomeworkDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var homeworkUUID: String!

    var homeworkData: [String: AnyObject]!

    var gradedHomeworkArray: [[String: AnyObject?]] = []
    var ungradedHomeworkArray: [[String: AnyObject?]] = []

    var navbarTitle: String?

    let homeworkViewModel = HomeworkViewModel()
    let submissionViewModel = SubmissionViewModel()

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    var homeworkAudioList = [[String: AnyObject]]()
    var homeworkImageURLList = [String]()

    var playingIndex: Int = -1
    var playingStatus: String = ""

    typealias DidCloseHomeworkClosureType = () -> Void
    var didCloseHomeworkBlock: DidCloseHomeworkClosureType?

    var currentPlayingIndex: (Int, Int) = (-1, -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "作业列表"
        self.initiateActionButton()
        self.initHomeworkData()
        self.initTableView()
        APIHomeworkGetSubmissionList(vc: self).run(self.homeworkUUID)
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.playingIndex = -1
        self.playingStatus = self.submissionKeys.AudioStatus.hidden
        self.reloadTable()
    }

    func didCloseHomeworkBlockSetter(didCloseHomework: DidCloseHomeworkClosureType) {
        self.didCloseHomeworkBlock = didCloseHomework
    }

    private func initHomeworkData() {
        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)
        if let audioList = homeworkData[self.submissionKeys.audioList] {
            self.homeworkAudioList = audioList as! [[String: AnyObject]]
        }
        if let imageURLs = homeworkData[self.submissionKeys.imageURLList] {
            self.homeworkImageURLList = imageURLs as! [String]
        }
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
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioPlayerTableViewCell")
    }

    func reloadTable() {
        let submissionsTup = self.submissionViewModel.getSubmissionList(self.homeworkUUID)
        self.ungradedHomeworkArray = submissionsTup.0
        self.gradedHomeworkArray = submissionsTup.1
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
            return self.ungradedHomeworkArray.count
        case 2:
            return self.gradedHomeworkArray.count
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
                if self.currentPlayingIndex == (indexPath.section, indexPath.row) {
                    let cell = tableView.dequeueReusableCellWithIdentifier("AudioPlayerTableViewCell") as! AudioPlayerTableViewCell
                    cell.configure(nil, audioURL: audioURL, duration: duration, play: true, exitPlayerBlock: {
                        self.currentPlayingIndex = (-1, -1)
                        self.tableView.reloadData()
                    })
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
                    cell.configurate(duration)
                    return cell
                }
                /*
                let cell = tableView.dequeueReusableCellWithIdentifier("HWAudioTableViewCell") as! HWAudioTableViewCell
                let currentIndex = indexPath.row - 1
                var status = self.submissionKeys.AudioStatus.hidden
                if currentIndex == self.playingIndex {
                    status = self.playingStatus
                }
                cell.configurate(rowDict, status: status, completePlay: {
                    self.playingIndex = -1
                    self.playingStatus = self.submissionKeys.AudioStatus.hidden
                })
                */

            } else if indexPath.row == self.homeworkAudioList.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWImagesTableViewCell") as! HWImagesTableViewCell
                cell.configurate(self.homeworkImageURLList.count)
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("HWStudentSubmitTableViewCell") as! HWStudentSubmitTableViewCell
            let data = self.ungradedHomeworkArray[indexPath.row]
            cell.configurate(data)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("HWStudentSubmitTableViewCell") as! HWStudentSubmitTableViewCell
            let data = self.gradedHomeworkArray[indexPath.row]
            cell.configurate(data)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            let submissionUUID = self.ungradedHomeworkArray[indexPath.row][self.submissionKeys.submissionUUID] as! String
            self.showHomeworkGradeVC(submissionUUID)
        } else if indexPath.section == 2 {
            let submissionUUID = self.gradedHomeworkArray[indexPath.row][self.submissionKeys.submissionUUID] as! String
            self.showHomeworkGradeVC(submissionUUID)
        } else if indexPath.section == 0 {
            if indexPath.row > 0 && indexPath.row < self.homeworkAudioList.count + 1 {
                /*
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
                */
                if self.currentPlayingIndex != (indexPath.section, indexPath.row) {
                    self.currentPlayingIndex = (indexPath.section, indexPath.row)
                    tableView.reloadData()
                }
            } else if indexPath.row == self.homeworkAudioList.count + 1 {
                self.showPhotoBrowser(self.homeworkImageURLList)
            }
        }

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        case 1:
            return 20
        case 2:
            return 20
        default:
            return 10
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "未批改的作业"
        case 2:
            return "已批改的作业"
        default:
            return nil
        }
    }

    private func showHomeworkGradeVC(submissionUUID: String) {
        let homeworkGradeVC = HomeworkGradeViewController(nibName: "HomeworkGradeViewController", bundle: nil)
        homeworkGradeVC.submissionUUID = submissionUUID
        self.navigationController?.pushViewController(homeworkGradeVC, animated: true)
    }

    func initiateActionButton() {
        let actionButton = UIBarButtonItem(title: "操作选项", style: .Plain, target: self, action: #selector(self.actionButtonOnClick))
        self.navigationItem.rightBarButtonItem = actionButton
    }

    func actionButtonOnClick(sender: AnyObject) {
        self.showHomeworkActionSheet()
    }

    private func showHomeworkActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "关闭当前作业", style: .Destructive, handler: { (action) in
            APIHomeworkClose(vc: self).run(self.homeworkUUID)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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


}
