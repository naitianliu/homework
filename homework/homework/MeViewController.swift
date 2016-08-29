//
//  MeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let kRoleMap = ["t": "教师", "s": "学生"]
    
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
            return 1
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
        case (2, 0):
            self.showLogoutActionSheet()
        default:
            break
        }

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

}
