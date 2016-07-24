//
//  AddSchoolViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class AddSchoolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let kSectionTitle = [
        0: "学校或机构名称",
        1: "学校或机构地址（可选）",
    ]

    @IBOutlet weak var tableView: UITableView!

    var schoolName: String?
    var schoolDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.registerNib(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
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
            self.reloadTable()
        }
    }

    @IBAction func confirmButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            self.reloadTable()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("InputTableViewCell") as! InputTableViewCell
            cell.configurate("输入学校或机构名称", returnValueBlock: { (value) in
                self.schoolName = value
                self.reloadTable()
            })
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell") as! DescriptionTableViewCell
            let title = "详细地址"
            cell.configure(title, value: schoolDescription)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = kSectionTitle[section]
        return title
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section, indexPath.row) == (0, 0) {
            return 50
        } else {
            return UITableViewAutomaticDimension
        }
    }

}
