//
//  CreateHWViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CreateHWViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var selectedClassroomUUID: String?
    var selectedClassroomName: String?
    var selectedDate: NSDate?
    var selectedType: String?
    var content: String?

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "EditTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "EditTextViewTableViewCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .OnDrag

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func submitButtonOnClick(sender: AnyObject) {
        self.performCreateHomework()
    }

    func reloadTable() {
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.configurate({ (text) in
                print(text)
                self.content = text
            })
            return cell
        case (1, 0):
            let cell = self.setupRightDetailCell("班级", detail: self.selectedClassroomName, imageName: "icon-classroom-gray")
            return cell
        case (1, 1):
            var dateString: String? = nil
            if let date = self.selectedDate {
                dateString = DateUtility().convertUTCDateToHumanFriendlyDateString(date)
            }
            let cell = self.setupRightDetailCell("截止时间", detail: dateString, imageName: "icon-clock-gray")
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
        case (1, 0):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
            self.showClassroomPickerVC()
        case (1, 1):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
            self.showCalendarDatePickerVC()
        default:
            break
        }
    }

    private func setupRightDetailCell(title: String, detail: String?, imageName: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.accessoryType = .DisclosureIndicator
        cell.imageView?.image = UIImage(named: imageName)
        cell.textLabel?.text = title
        if let detail = detail {
            cell.detailTextLabel?.text = detail
        } else {
            cell.detailTextLabel?.text = "未选择"
        }
        return cell
    }

    private func showCalendarDatePickerVC() {
        let calendarDatePickerVC = CalendarDatePickerViewController(nibName: "CalendarDatePickerViewController", bundle: nil)
        calendarDatePickerVC.completeSelectionBlockSetter { (date) in
            self.selectedDate = date
        }
        self.navigationController?.pushViewController(calendarDatePickerVC, animated: true)
    }

    private func showClassroomPickerVC() {
        let classroomPickerVC = ClassroomPickerViewController(nibName: "ClassroomPickerViewController", bundle: nil)
        classroomPickerVC.completeSelectionBlockSetter { (classroomUUID, classroomName) in
            self.selectedClassroomUUID = classroomUUID
            self.selectedClassroomName = classroomName
        }
        self.navigationController?.pushViewController(classroomPickerVC, animated: true)
    }

    private func performCreateHomework() {
        let classroomUUID: String = self.selectedClassroomUUID!
        let type: String = self.selectedType!
        let dueDateTimestamp: Int = DateUtility().convertDateToEpoch(self.selectedDate!)
        let info: [String: AnyObject] = [
            self.homeworkKeys.type: type,
            self.homeworkKeys.content: content!,
            self.homeworkKeys.dueDateTimestamp: dueDateTimestamp,
        ]
        APIHomeworkCreate(vc: self).run(classroomUUID, info: info)
    }

}
