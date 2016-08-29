//
//  HomeworkGradeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomeworkGradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var actionView: UIView!

    var homeworkData: [String: String?] = ["name": "比尔盖茨4", "time": "今天 14:00", "score": nil, "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"]

    var submissionArray: [[String: String]] = [
        ["duration": "5:40", "status": "pending"],
        ["duration": "0:46", "status": "working"],
        ["duration": "0:46", "status": "complete"]
    ]

    var comments: [[String: AnyObject?]] = [
        ["name": "比尔盖茨4", "time": "今天 14:00", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg", "content": "美国航天局所属的的朱诺号宇宙飞船上的探测器上个月进入环绕木星轨道，27日，朱诺号陆续传送回一些木星云层图片。这可说是人类有史以来，观察木星最近的距离。美国太空总署28日上午开始发布一些接近木星的图片，这些图片是目前为止，人类运用科技观测木星最为清晰的图片。", "audio": nil],
        ["name": "比尔盖茨4", "time": "今天 14:00", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg", "content": "朱诺号发回有史以来最清晰木星照片 画面震撼", "audio": nil],
        ["name": "比尔盖茨4", "time": "今天 14:00", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg", "content": "朱诺号发回有史以来最清晰木星照片 画面震撼", "audio": ["duration": "5:40", "playing": false]]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.renderActionView()
        self.setupActionView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerNib(UINib(nibName: "HWStudentSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "HWStudentSubmitTableViewCell")
        tableView.registerNib(UINib(nibName: "HWAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "HWAudioTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommetTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommetTextTableViewCell")
        tableView.registerNib(UINib(nibName: "HWCommentTextAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "HWCommentTextAudioTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 + submissionArray.count
        case 1:
            return comments.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWStudentSubmitTableViewCell") as! HWStudentSubmitTableViewCell
                cell.separatorHidden = true
                cell.configurate(homeworkData)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWAudioTableViewCell") as! HWAudioTableViewCell
                let rowDict = submissionArray[indexPath.row - 1]
                let duration: String = rowDict["duration"]!
                let status: String = rowDict["status"]!
                cell.configurate(duration, status: status)
                return cell
            }
        } else if indexPath.section == 1 {
            let rowDict = comments[indexPath.row]
            let audio: [String: AnyObject]? = rowDict["audio"]! as! [String: AnyObject]?
            if audio == nil {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWCommetTextTableViewCell") as! HWCommetTextTableViewCell
                cell.configurate(rowDict)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HWCommentTextAudioTableViewCell") as! HWCommentTextAudioTableViewCell
                cell.configurate(rowDict)
                return cell
            }
        } else {
            return UITableViewCell()
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
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "评论"
        default:
            return nil
        }
    }

    private func setupActionView() {
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let kRadio: CGFloat = 104/136
        let kOffsetX: CGFloat = 50
        let kOffsetY: CGFloat = 10
        let kBtnWidth: CGFloat = 60 * kRadio
        let kBtnHeight: CGFloat = 60
        let gap: CGFloat = (screenWidth - kOffsetX * 2 - kBtnWidth * 3) / 2
        // init grade button
        let gradeButton = UIButton(frame: CGRect(x: kOffsetX, y: kOffsetY, width: kBtnWidth, height: kBtnHeight))
        gradeButton.setBackgroundImage(UIImage(named: "button-grade-bg"), forState: .Normal)
        gradeButton.addTarget(self, action: #selector(self.gradeButtonOnClick), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(gradeButton)
        // init comment button
        let commentButton = UIButton(frame: CGRect(x: kOffsetX + kBtnWidth + gap, y: kOffsetY, width: kBtnWidth, height: kBtnHeight))
        commentButton.setBackgroundImage(UIImage(named: "button-comment-bg"), forState: .Normal)
        commentButton.addTarget(self, action: #selector(self.commentButtonOnClick), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(commentButton)
        // init share button
        let shareButton = UIButton(frame: CGRect(x: kOffsetX + kBtnWidth * 2 + gap * 2, y: kOffsetY, width: kBtnWidth, height: kBtnHeight))
        shareButton.setBackgroundImage(UIImage(named: "button-share-bg"), forState: .Normal)
        shareButton.addTarget(self, action: #selector(self.shareButtonOnClick), forControlEvents: .TouchUpInside)
        self.actionView.addSubview(shareButton)

    }

    private func renderActionView() {
        actionView.backgroundColor = UIColor.whiteColor()
        actionView.layer.shadowOffset = CGSize(width: 2, height: 3)
        actionView.layer.shadowColor = UIColor.grayColor().CGColor
        actionView.layer.shadowRadius = 3
        actionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        actionView.layer.borderWidth = 1
    }
    
    func gradeButtonOnClick(sender: AnyObject) {
        print("grade")
    }

    func commentButtonOnClick(sender: AnyObject) {
        print("comment")
    }

    func shareButtonOnClick(sender: AnyObject) {
        print("share")
    }

}
