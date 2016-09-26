//
//  MembersViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage

class MembersPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let profiles = ProfileModelHelper().getList()

    let myUserId = UserDefaultsHelper().getUsername()!

    let profileKeys = GlobalKeys.ProfileKeys.self

    var tableData = []
    var indexArray = []

    var selectedUserIdList: [String] = []

    var navbarTitle: String?

    var pickme: Bool = false

    typealias CompleteSelectionClosureType = (selectedUsers: [String]) -> Void
    var completeSelectionBlock: CompleteSelectionClosureType?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if let navbarTitle = navbarTitle {
            self.navigationItem.title = navbarTitle
        } else {
            self.navigationItem.title = "选择班级成员"
        }

        self.initTableData()

        self.initiateConfirmButton()

        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func reloadTable() {
        tableView.reloadData()
    }

    func completeSelectionBlockSetter(completion: CompleteSelectionClosureType) {
        self.completeSelectionBlock = completion
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows:[AnyObject] = self.tableData[section] as! [AnyObject]
        return rows.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let letter = self.indexArray[section] as! String
        return letter
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberTableViewCell") as! MemberTableViewCell
        let rowArray: [AnyObject] = self.tableData[indexPath.section] as! [AnyObject]
        let contactInfo: [String:String] = rowArray[indexPath.row] as! [String:String]
        let nickname: String = contactInfo[self.profileKeys.nickname]!
        let imgURL: String = contactInfo[self.profileKeys.imgURL]!
        let userId: String = contactInfo[self.profileKeys.userId]!
        let selected: Bool = selectedUserIdList.contains(userId)
        cell.configurate(nickname, imgURL: imgURL, selected: selected)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowArray: [AnyObject] = self.tableData[indexPath.section] as! [AnyObject]
        let contactInfo: [String:String] = rowArray[indexPath.row] as! [String:String]
        let userId: String = contactInfo[self.profileKeys.userId]!
        if selectedUserIdList.contains(userId) {
            if pickme && userId == myUserId {
                AlertHelper(viewController: self).showPromptAlertView("教师成员中需要包含自己")
            } else {
                selectedUserIdList.removeObject(userId)
            }
        } else {
            selectedUserIdList.append(userId)
        }
        self.reloadTable()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    func initiateConfirmButton() {
        let confirmButton = UIBarButtonItem(title: "完成选择", style: .Plain, target: self, action: #selector(self.confirmButtonOnClick))
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    func confirmButtonOnClick(sender: AnyObject) {
        self.completeSelectionBlock!(selectedUsers: self.selectedUserIdList)
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func initTableData() {
        var contactDict:[String:AnyObject] = [:]
        var contactArray:[String] = []
        var nameUserIdArrayDict: [String: [String]] = [:]
        for  item in self.profiles {
            let contactInfo = item 
            let name = contactInfo[profileKeys.nickname]
            let userId = contactInfo[profileKeys.userId]
            if let userIdArray = nameUserIdArrayDict[name!] {
                var tempArray = userIdArray
                tempArray.append(userId!)
                nameUserIdArrayDict[name!] = tempArray
            } else {
                nameUserIdArrayDict[name!] = [userId!]
            }
            if !contactArray.contains(name!) {
                contactArray.append(name!)
            }
            contactDict[userId!] = item
        }
        self.indexArray = ChineseString.IndexArray(contactArray)
        let letterResultArray = ChineseString.LetterSortArray(contactArray)
        var newArray: [[AnyObject]] = []
        for letterRow in letterResultArray {
            let rowArray:[String] = letterRow as! [String]
            var tempArray:[AnyObject] = []
            for item in rowArray {
                let name:String = item
                for userId in nameUserIdArrayDict[name]! {
                    let info = contactDict[userId]
                    tempArray.append(info!)
                }
            }
            newArray.append(tempArray)
        }
        self.tableData = newArray
    }

}
