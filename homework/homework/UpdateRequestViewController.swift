//
//  UpdateRequestViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class UpdateRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var updateData: [String: AnyObject]?

    var classroomData: [String: AnyObject]?

    let classroomModelHelper = ClassroomViewModel()

    let classroomKeys = GlobalKeys.ClassroomKeys.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "SearchClassroomTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchClassroomTableViewCell")
        tableView.registerNib(UINib(nibName: "UpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "UpdateTableViewCell")
        tableView.registerNib(UINib(nibName: "ActionButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ActionButtonTableViewCell")

        if let updateData = updateData {
            let classroomUUID: String = updateData[self.classroomKeys.classroomUUID]! as! String
            self.classroomData = self.classroomModelHelper.getClassroomDataByUUID(classroomUUID)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 2
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("UpdateTableViewCell") as! UpdateTableViewCell
            cell.selectionStyle = .None
            if let rowDict = self.updateData {
                cell.configurate(rowDict)
            }
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchClassroomTableViewCell") as! SearchClassroomTableViewCell
            cell.selectionStyle = .None
            if let rowData = self.classroomData {
                cell.configurate(rowData)
            }
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("ActionButtonTableViewCell") as! ActionButtonTableViewCell
            cell.configurate("同意并添加为班级成员", bgColor: GlobalConstants.themeColor, action: {
                // approve action
            })
            return cell
        case (2, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("ActionButtonTableViewCell") as! ActionButtonTableViewCell
            cell.configurate("拒绝申请", bgColor: UIColor.redColor(), action: {
                // reject action
            })
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

}
