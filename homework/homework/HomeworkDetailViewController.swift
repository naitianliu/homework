//
//  HomeworkDetailViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomeworkDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var homeworkUUID: String!

    var homeworkData: [String: AnyObject]!

    var gradedHomeworkArray: [[String: String?]] = [
        ["name": "比尔盖茨1", "time": "今天 14:00", "score": "A", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
        ["name": "比尔盖茨2", "time": "今天 14:00", "score": "B", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
        ["name": "比尔盖茨3", "time": "今天 14:00", "score": "A", "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
    ]
    var ungradedHomeworkArray: [[String: String?]] = [
        ["name": "比尔盖茨4", "time": "今天 14:00", "score": nil, "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
        ["name": "比尔盖茨5", "time": "今天 14:00", "score": nil, "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
    ]

    var navbarTitle: String?

    let homeworkViewModel = HomeworkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "作业列表"
        self.initiateActionButton()

        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        // tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()

        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")
        tableView.registerNib(UINib(nibName: "HWStudentSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "HWStudentSubmitTableViewCell")

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
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
            cell.configurate(homeworkData)
            return cell
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
        let homeworkGradeVC = HomeworkGradeViewController(nibName: "HomeworkGradeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeworkGradeVC, animated: true)
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

    func initiateActionButton() {
        let actionButton = UIBarButtonItem(title: "操作选项", style: .Plain, target: self, action: #selector(self.actionButtonOnClick))
        self.navigationItem.rightBarButtonItem = actionButton
    }

    func actionButtonOnClick(sender: AnyObject) {

    }


}
