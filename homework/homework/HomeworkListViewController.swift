//
//  HomeworkListViewController.swift
//  homework
//
//  Created by Liu, Naitian on 10/7/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomeworkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let homeworkViewModel = HomeworkViewModel()

    var openHomeworkArray: [[String: AnyObject]] = []
    var closedHomeworkArray: [[String: AnyObject]] = []

    var classroomUUID: String!

    let role = UserDefaultsHelper().getRole()!

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "该班级所有作业"

        self.initTableView()

        self.reloadTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")
    }

    func reloadTable() {
        let homeworksTup = self.homeworkViewModel.getAllHomeworkList(classroomUUID)
        self.openHomeworkArray = homeworksTup.0
        self.closedHomeworkArray = homeworksTup.1
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.openHomeworkArray.count
        case 1:
            return self.closedHomeworkArray.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var rowDict: [String: AnyObject]!
        if indexPath.section == 0 {
            rowDict = self.openHomeworkArray[indexPath.row]
        } else {
            rowDict = self.closedHomeworkArray[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
        cell.configurate(rowDict)
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "当前作业"
        case 1:
            return "已关闭作业"
        default:
            return nil
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var rowDict: [String: AnyObject]!
        if indexPath.section == 0 {
            rowDict = self.openHomeworkArray[indexPath.row]
        } else {
            rowDict = self.closedHomeworkArray[indexPath.row]
        }
        let homeworkUUID: String = rowDict[self.homeworkKeys.homeworkUUID]! as! String
        self.showHomeworkDetailVC(homeworkUUID)
    }

    private func showHomeworkDetailVC(homeworkUUID: String) {
        if self.role == "t" {
            let homeworkDetailVC = HomeworkDetailViewController(nibName: "HomeworkDetailViewController", bundle: nil)
            homeworkDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewController(homeworkDetailVC, animated: true)
        } else if self.role == "s" {
            let studentHWDetailVC = StudentHomeworkDetailViewController(nibName: "StudentHomeworkDetailViewController", bundle: nil)
            studentHWDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewController(studentHWDetailVC, animated: true)
        }

    }


}
