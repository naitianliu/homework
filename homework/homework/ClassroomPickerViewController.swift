//
//  ClassroomPickerViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ClassroomPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var dataArray: [[String: AnyObject]] = []

    typealias CompleteSelectionClosureType = (classroomUUID: String, classroomName: String) -> Void
    var completeSelectionBlock: CompleteSelectionClosureType?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        dataArray = ClassroomViewModel().getTableViewData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func completeSelectionBlockSetter(completion: CompleteSelectionClosureType) {
        self.completeSelectionBlock = completion
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        let rowDict: [String: AnyObject] = dataArray[indexPath.row]
        let classroomName: String = rowDict["classroomName"]! as! String
        let schoolName: String = rowDict["schoolName"]! as! String
        cell.textLabel?.text = classroomName
        cell.detailTextLabel?.text = schoolName
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowDict: [String: AnyObject] = dataArray[indexPath.row]
        let classroomName: String = rowDict["classroomName"]! as! String
        let classroomUUID: String = rowDict["classroomUUID"]! as! String
        self.completeSelectionBlock!(classroomUUID: classroomUUID, classroomName: classroomName)
        self.navigationController?.popViewControllerAnimated(true)

    }

}
