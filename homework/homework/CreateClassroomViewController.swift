//
//  CreateClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CreateClassroomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var classroomName: String?
    var teacherNumber: Int = 1
    var studentNumber: Int = 0
    var school: String?
    var classroomDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func reloadTable() {
        tableView.reloadData()
    }

    @IBAction func cancelButtonOnClick(sender: AnyObject) {

    }

    @IBAction func doneButtonOnClick(sender: AnyObject) {

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 2
        } else {
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section, indexPath.row) == (2, 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell") as! DescriptionTableViewCell
            let title = "班级描述"
            let value = classroomDescription
            cell.configure(title, value: value)
            return cell
        }
        let cell = ParameterTableViewCell()
        var title: String?
        var value: String?
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            title = "班级名称"
            value = classroomName!
        case (1, 0):
            title = "所属学校或机构"
            value = school
        case (3, 0):
            title = "全部教师"
            value = String(teacherNumber)
        case (3, 1):
            title = "全部学生"
            value = String(studentNumber)
        default:
            break
        }
        cell.configurate(title, value: value)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
