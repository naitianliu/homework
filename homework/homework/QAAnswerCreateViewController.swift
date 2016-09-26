//
//  QAAnswerCreateViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class QAAnswerCreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var anonymous: Bool = true
    var answerContent: String?
    var classroomUUID: String?
    var classroomName: String?

    var questionUUID: String?

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initiateConfirmButton()
        self.initTableView()

        let classroomArray = ClassroomModelHelper().getList(true)
        if classroomArray.count > 0 {
            let classroomInfo = classroomArray[0]
            let firstClassroomUUID = classroomInfo[self.classroomKeys.classroomUUID] as! String
            let firstClassroomName = classroomInfo[self.classroomKeys.classroomName] as! String
            self.classroomUUID = firstClassroomUUID
            self.classroomName = firstClassroomName
        }
        self.tableView.reloadData()

        self.navigationItem.title = "发布回答"

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
    }

    private func initiateConfirmButton() {
        let confirmButton = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: #selector(self.confirmButtonOnClick))
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    func confirmButtonOnClick(sender: AnyObject) {
        guard let classroomUUID = self.classroomUUID else {
            AlertHelper(viewController: self).showPromptAlertView("请选择班级")
            return
        }
        guard let content = self.answerContent else {
            AlertHelper(viewController: self).showPromptAlertView("回答不能为空")
            return
        }
        APIQAAnswerCreate(vc: self).run(questionUUID!, classroomUUID: classroomUUID, anonymous: self.anonymous, content: content)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.placeholder = "编写回答"
            cell.configurate({ (text) in
                self.answerContent = text
            })
            return cell
        case 1:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "来自于班级"
            if let classroomName = self.classroomName {
                cell.detailTextLabel?.text = classroomName
            }
            return cell
        case 2:
            let cell = SwitchTableViewCell(style: .Default, reuseIdentifier: "SwitchTableViewCell")
            cell.configurate("匿名提问", defaultOn: self.anonymous, switchChange: { (on) in
                self.anonymous = on
            })
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let classroomPickerVC = ClassroomPickerViewController(nibName: "ClassroomPickerViewController", bundle: nil)
            classroomPickerVC.completeSelectionBlockSetter({ (classroomUUID, classroomName) in
                self.classroomUUID = classroomUUID
                self.classroomName = classroomName
            })
            self.navigationController?.pushViewController(classroomPickerVC, animated: true)
        }
    }



}
