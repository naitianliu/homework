//
//  ClassroomInfoViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Diplomat

class ClassroomInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let classroomViewModel = ClassroomViewModel()

    var dataDict: [String: AnyObject]!

    var classroomUUID: String!

    var teachers: [String] = []
    var students: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "班级信息"

        self.initTableView()

        self.reloadTable()

        if let role = UserDefaultsHelper().getRole() {
            if role == "t" {
                self.initiateActionButton()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
    }

    func reloadTable() {
        self.dataDict = self.classroomViewModel.getClassroomDetailedInfoByUUID(classroomUUID)!
        self.teachers = self.dataDict[self.classroomKeys.teachers] as! [String]
        self.students = self.dataDict[self.classroomKeys.students] as! [String]
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let classroomName: String = self.dataDict[self.classroomKeys.classroomName] as! String
        let schoolName: String = self.dataDict[self.classroomKeys.schoolName] as! String
        let introduction: String = self.dataDict[self.classroomKeys.introduction] as! String
        let code: String = self.dataDict[self.classroomKeys.code] as! String
        let teacherNumber: String = self.dataDict[self.classroomKeys.teacherNumber] as! String
        let studentNumber: String = self.dataDict[self.classroomKeys.studentNumber] as! String
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "班级名称"
            cell.detailTextLabel?.text = classroomName
            return cell
        case (0, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "所属学校或机构"
            cell.detailTextLabel?.text = schoolName
            return cell
        case (0, 2):
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell") as! DescriptionTableViewCell
            cell.configure("班级描述", value: introduction)
            return cell
        case (0, 3):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "班级二维码"
            cell.detailTextLabel?.text = code
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "全部教师"
            cell.detailTextLabel?.text = teacherNumber
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "全部学生"
            cell.detailTextLabel?.text = studentNumber
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let code: String = self.dataDict[self.classroomKeys.code] as! String
        switch (indexPath.section, indexPath.row) {
        case (0, 3):
            self.showShareCodeActionSheet(code)
        case (1, 0):
            self.showMembersPicker(true)
        case (1, 1):
            self.showMembersPicker(false)
        default:
            break
        }
    }

    private func showMembersPicker(teacher: Bool) {
        let membersVC = MembersPickerViewController(nibName: "MembersPickerViewController", bundle: nil)
        if teacher {
            membersVC.pickme = true
            membersVC.selectedUserIdList = teachers
            membersVC.completeSelectionBlockSetter({ (selectedUsers) in
                APIClassroomUpdate(vc: self).updateMembers(self.classroomUUID, teachers: selectedUsers, students: self.students)
            })
        } else {
            membersVC.pickme = false
            membersVC.selectedUserIdList = students
            membersVC.completeSelectionBlockSetter({ (selectedUsers) in
                APIClassroomUpdate(vc: self).updateMembers(self.classroomUUID, teachers: self.teachers, students: selectedUsers)
            })
        }
        self.navigationController?.pushViewController(membersVC, animated: true)
    }

    private func showShareCodeActionSheet(code: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "分享班级代码给微信好友", style: .Default, handler: { (action) in
            // share weixin
            self.forwardMessageViaWechat(code)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func forwardMessageViaWechat(code: String) {
        let message = "使用此班级代码（\(code)）加入班级。打开窗外APP，点击班级页面左上角的搜索按钮，在搜索框中输入班级代码（\(code)），选择班级并点击加入班级按钮，教师确认后即可成为班级成员。"
        let dtMessage = DTTextMessage()
        dtMessage.text = message
        dtMessage.userInfo = [kWechatSceneTypeKey: Int(WXSceneSession.rawValue)]
        Diplomat.sharedInstance().share(dtMessage, name: kDiplomatTypeWechat) { (result, error) in
            print(result)
        }
    }

    private func initiateActionButton() {
        let actionButton = UIBarButtonItem(title: "选项", style: .Plain, target: self, action: #selector(self.actionButtonOnClick))
        self.navigationItem.rightBarButtonItem = actionButton
    }

    func actionButtonOnClick(sender: AnyObject) {
        self.showClassroomActionSheet()
    }

    private func showClassroomActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "关闭当前班级", style: .Destructive, handler: { (action) in
            APIClassroomClose(vc: self).run(self.classroomUUID, completion: { 
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
