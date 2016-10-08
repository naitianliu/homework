//
//  MemebrListViewController.swift
//  homework
//
//  Created by Liu, Naitian on 10/8/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var tableData: [[String: String]] = []

    let classroomViewModel = ClassroomViewModel()

    let profileKeys = GlobalKeys.ProfileKeys.self

    var classroomUUID: String!

    var type: String = "t"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()

        if type == "t" {
            self.navigationItem.title = "班级教师"
        } else if type == "s" {
            self.navigationItem.title = "班级学生"
        }

        self.reloadTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberTableViewCell")
    }

    func reloadTable() {
        let tsProfilesTup = self.classroomViewModel.getTeacherAndStudentProfiles(classroomUUID)
        if type == "t" {
            self.tableData = tsProfilesTup.0
        } else if type == "s" {
            self.tableData = tsProfilesTup.1
        }
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberTableViewCell") as! MemberTableViewCell
        let rowDict = self.tableData[indexPath.row]
        let nickname = rowDict[self.profileKeys.nickname]!
        let imgURL = rowDict[self.profileKeys.imgURL]!
        cell.configurate(nickname, imgURL: imgURL, selected: false)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
