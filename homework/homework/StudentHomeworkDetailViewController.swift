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

    var navbarTitle: String?

    let homeworkViewModel = HomeworkViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")

        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)

        self.setupActionView()
        self.renderActionView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
            cell.selectionStyle = .None
            cell.configurate(homeworkData)
            return cell
        default:
            return UITableViewCell()
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
        print("submit")
        self.showAudioWHRecordVC()
    }

    func commentButtonOnClick(sender: AnyObject) {
        print("comment")

    }

    private func showAudioWHRecordVC() {
        let audioHWRecordVC = AudioHWRecordViewController(nibName: "AudioHWRecordViewController", bundle: nil)
        audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL) in
            print(duration)
            print(filename)
            print(audioURL)
        }
        self.navigationController?.pushViewController(audioHWRecordVC, animated: true)
    }


}
