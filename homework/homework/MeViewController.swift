//
//  MeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Diplomat
import MBProgressHUD

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let kRoleMap = ["t": "教师", "s": "学生"]

    var role = UserDefaultsHelper().getRole()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: "LogoutTableViewCell")

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func reloadTable() {
        role = UserDefaultsHelper().getRole()
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let role = role {
                if role == "t" {
                    return 3
                } else {
                    return 1
                }
            } else {
                return 1
            }
        case 2:
            return 1
        default:
            return 1
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileDisplayTableViewCell") as! ProfileDisplayTableViewCell
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "当前角色"
            if let role = UserDefaultsHelper().getRole() {
                cell.detailTextLabel?.text = kRoleMap[role]!
            }
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "生成并发送邀请码"
            return cell
        case (1, 2):
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "管理我的学校或机构"
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("LogoutTableViewCell") as! LogoutTableViewCell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 80
        default:
            return 44
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let updateProfileNC = self.storyboard?.instantiateViewControllerWithIdentifier("UpdateProfileNC") as! UINavigationController
            updateProfileNC.modalTransitionStyle = .CoverVertical
            self.presentViewController(updateProfileNC, animated: true, completion: nil)
        case (1, 0):
            self.showConfirmRoleSelectionAlertView()
        case (1, 1):
            self.apiGenerateCode()
        case (1, 2):
            self.showSchoolVC()
        case (2, 0):
            self.showLogoutActionSheet()
        default:
            break
        }
    }

    private func showSchoolVC() {
        let classroomSB = UIStoryboard(name: "Classroom", bundle: nil)
        let schoolVC = classroomSB.instantiateViewControllerWithIdentifier("SelectSchoolViewController") as! SelectSchoolViewController
        schoolVC.forSelect = false
        self.navigationController?.pushViewController(schoolVC, animated: true)
    }

    private func showLogoutActionSheet() {
        let alertController = UIAlertController(title: "确定推出登录吗？", message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "退出登录", style: .Destructive, handler: { (action) in
            print("logout")
            ProfileUpdateHelper(vc: self).logout()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func showConfirmRoleSelectionAlertView() {
        let alertController = UIAlertController(title: "确定切换角色吗？", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "切换", style: .Default, handler: { (action) in
            print("switch role")
            ProfileUpdateHelper(vc: self).switchRole()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func apiGenerateCode() {
        self.showHUD()
        let url = APIURL.authInvitationCodeGenerate
        CallAPIHelper(url: url, data: nil).GET({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let code = responseData["code"].stringValue
                self.showInvitationCodeAlert(code)
            }
            }) { (error) in
                // error
                self.hideHUD()
        }
    }

    private func showInvitationCodeAlert(code: String) {
        let alertMessage = "生成的邀请码：\(code)"
        let alertController = UIAlertController(title: "邀请码已生成", message: alertMessage, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "发送给微信好友", style: .Destructive, handler: { (action) in
            //
            self.forwardMessageViaWechat(code)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func forwardMessageViaWechat(code: String) {
        let message = "窗外APP邀请码：\(code)"
        let dtMessage = DTTextMessage()
        dtMessage.text = message
        dtMessage.userInfo = [kWechatSceneTypeKey: Int(WXSceneSession.rawValue)]
        Diplomat.sharedInstance().share(dtMessage, name: kDiplomatTypeWechat) { (result, error) in
            print(result)
        }
    }

    private func showHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }

    }

    private func hideHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }

}

