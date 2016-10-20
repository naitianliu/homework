//
//  HomeworkCommentViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomeworkCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var audioDuration: NSTimeInterval?
    var audioURL: String?

    var commentText: String?

    var submissionUUID: String!

    let commentKeys = GlobalKeys.CommentKeys.self

    var confirmButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()

        initBarItems()

        self.navigationItem.title = "编辑评论"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerNib(UINib(nibName: "EditTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "EditTextViewTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.keyboardDismissMode = .OnDrag
    }

    private func initBarItems() {
        let cancelButton = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(self.cancelButtonOnClick))
        self.navigationItem.leftBarButtonItem = cancelButton
        self.confirmButton = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(self.confirmButtonOnClick))
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    @objc private func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func enableConfirmButton() {
        self.confirmButton.enabled = true
    }

    func disableConfirmButton() {
        self.confirmButton.enabled = false
    }

    @objc private func confirmButtonOnClick(sender: AnyObject) {
        guard let submissionUUID = submissionUUID else { return }
        guard let commentText = commentText else {
            AlertHelper(viewController: self).showPromptAlertView("评论内容不能为空")
            return
        }
        var info: [String: AnyObject] = [
            self.commentKeys.text: commentText
        ]
        if let audioDuration = audioDuration, let audioURL = audioURL {
            let audioInfo: [String: AnyObject] = [
                self.commentKeys.duration: Int(audioDuration),
                self.commentKeys.audioURL: audioURL
            ]
            info[self.commentKeys.audioInfo] = audioInfo
        }
        APICommentCreate(vc: self).run(submissionUUID, info: info)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.placeholder = "编辑评论内容"
            cell.configurate({ (text) in
                print(text)
                self.commentText = text
            })
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
            cell.configurate(audioDuration)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 1 {
            self.showAudioRecordVC()
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    private func showAudioRecordVC() {
        if audioDuration == nil {
            let audioHWRecordVC = AudioHWRecordViewController(nibName: "AudioHWRecordViewController", bundle: nil)
            audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL) in
                self.audioDuration = duration
                self.audioURL = audioURL
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(audioHWRecordVC, animated: true)
        } else {
            let alertController = UIAlertController(title: "提示", message: "已有录音，确定要放弃并重新录音吗", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "重新录音", style: .Destructive, handler: { (action) in
                self.audioDuration = nil
                self.audioURL = nil
                self.showAudioRecordVC()
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
