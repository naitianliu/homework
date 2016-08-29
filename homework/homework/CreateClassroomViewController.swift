//
//  CreateClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CreateClassroomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveInputVCDelegate {

    @IBOutlet weak var tableView: UITableView!

    let myUserId = UserDefaultsHelper().getUsername()!

    var classroomName: String?
    var schoolUUID: String?
    var schoolName: String?
    var classroomDescription: String?
    var teachers: [String] = []
    var students: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        if teachers.count == 0 {
            teachers = [myUserId]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func reloadTable() {
        tableView.reloadData()
    }

    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 

        }
    }

    @IBAction func doneButtonOnClick(sender: AnyObject) {
        if self.checkInputs() {
            var members: [[String: String]] = []
            for userId in self.teachers {
                let rowDict: [String: String] = ["role": "t", "user_id": userId]
                members.append(rowDict)
            }
            for userId in self.students {
                let rowDict: [String: String] = ["role": "s", "user_id": userId]
                members.append(rowDict)
            }
            APIClassroomCreate(vc: self).run(classroomName!, schoolUUID: schoolUUID!, introduction: classroomDescription!, members: members)
        }
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
            let title = "班级介绍"
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
            value = schoolName
        case (3, 0):
            title = "全部教师"
            value = String(teachers.count)
        case (3, 1):
            title = "全部学生"
            value = String(students.count)
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
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.showSaveInputVCForName()
        case (1, 0):
            self.showSelectSchoolVC()
        case (2, 0):
            self.showEditDescriptionVC()
        case (3, 0):
            self.showMembersPicker(true)
        case (3, 1):
            self.showMembersPicker(false)
        default:
            break
        }
    }

    private func showSaveInputVCForName() {
        let meStoryboard = UIStoryboard(name: "Me", bundle: nil)
        let saveInputVC = meStoryboard.instantiateViewControllerWithIdentifier("SaveInputViewController") as! SaveInputViewController
        saveInputVC.navbarTitle = "班级名称"
        saveInputVC.delegate = self
        self.navigationController?.pushViewController(saveInputVC, animated: true)
    }

    private func showSelectSchoolVC() {
        let selectSchoolVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectSchoolViewController") as! SelectSchoolViewController
        selectSchoolVC.completeSelectionBlockSetter { (id, name) in
            // select id, name
            self.schoolName = name
            self.schoolUUID = id
            self.reloadTable()

        }
        self.navigationController?.pushViewController(selectSchoolVC, animated: true)
    }

    private func showEditDescriptionVC() {
        let editTextVC = EditTextViewController(nibName: "EditTextViewController", bundle: nil)
        editTextVC.navbarTitle = "编辑班级介绍"
        editTextVC.completionEditBlockSetter({ (text) in
            self.classroomDescription = text
            self.reloadTable()
        })
        self.navigationController?.pushViewController(editTextVC, animated: true)
    }

    private func showMembersPicker(teacher: Bool) {
        let membersVC = MembersPickerViewController(nibName: "MembersPickerViewController", bundle: nil)
        if teacher {
            membersVC.pickme = true
            membersVC.selectedUserIdList = teachers
            membersVC.completeSelectionBlockSetter({ (selectedUsers) in
                self.teachers = selectedUsers
                self.reloadTable()
            })
        } else {
            membersVC.pickme = false
            membersVC.selectedUserIdList = students
            membersVC.completeSelectionBlockSetter({ (selectedUsers) in
                self.students = selectedUsers
                self.reloadTable()
            })
        }
        self.navigationController?.pushViewController(membersVC, animated: true)
    }

    private func checkInputs() -> Bool{
        if classroomName == nil {
            AlertHelper(viewController: self).showPromptAlertView("请输入班级名称")
            return false
        }
        if classroomDescription == nil {
            AlertHelper(viewController: self).showPromptAlertView("请输入班级介绍")
            return false
        }
        if schoolUUID == nil {
            AlertHelper(viewController: self).showPromptAlertView("请选择班级所属学校或机构")
            return false
        }
        return true
    }

    func didFinishedInputToSave(input: String) {
        classroomName = input
        self.reloadTable()
    }

}
