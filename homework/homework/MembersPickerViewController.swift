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

    let profiles = [
        ["userId": "1", "nickname": "比尔盖茨", "imgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"],
        ["userId": "2", "nickname": "乔布斯", "imgURL": ""],
        ["userId": "3", "nickname": "Ali", "imgURL": ""],
    ]

    var tableData = []
    var indexArray = []

    var selectedUserIdList: [String] = []

    var navbarTitle: String?

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
        let nickname: String = contactInfo["nickname"]!
        let imgURL: String = contactInfo["imgURL"]!
        let userId: String = contactInfo["userId"]!
        let selected: Bool = selectedUserIdList.contains(userId)
        cell.configurate(nickname, imgURL: imgURL, selected: selected)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowArray: [AnyObject] = self.tableData[indexPath.section] as! [AnyObject]
        let contactInfo: [String:String] = rowArray[indexPath.row] as! [String:String]
        let userId: String = contactInfo["userId"]!
        if selectedUserIdList.contains(userId) {
            selectedUserIdList.removeObject(userId)
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

    }

    private func initTableData() {
        var contactDict:[String:AnyObject] = [:]
        var contactArray:[String] = []
        for  item in self.profiles {
            let contactInfo = item 
            let name = contactInfo["nickname"]
            contactArray.append(name!)
            contactDict[name!] = item
        }
        print(contactDict)
        self.indexArray = ChineseString.IndexArray(contactArray)
        print(indexArray)
        let letterResultArray = ChineseString.LetterSortArray(contactArray)
        print(letterResultArray)
        var newArray:[[AnyObject]] = []
        for letterRow in letterResultArray {
            let rowArray:[String] = letterRow as! [String]
            print(rowArray)
            var tempArray:[AnyObject] = []
            for item in rowArray {
                let name:String = item
                let info = contactDict[name]
                tempArray.append(info!)
            }
            newArray.append(tempArray)
        }
        self.tableData = newArray
    }

}
