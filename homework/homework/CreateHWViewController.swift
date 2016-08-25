//
//  CreateHWViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class CreateHWViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var homeworkTypeIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "EditTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "EditTextViewTableViewCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .OnDrag

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func submitButtonOnClick(sender: AnyObject) {

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.configurate({ (text) in
                print(text)
            })
            return cell
        case (1, 0):
            let cell = self.setupRightDetailCell("班级", detail: "", imageName: "icon-classroom-gray")
            return cell
        case (1, 1):
            let cell = self.setupRightDetailCell("截止时间", detail: "", imageName: "icon-clock-gray")
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
        case (1, 1):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
        default:
            break
        }
    }

    private func setupRightDetailCell(title: String, detail: String, imageName: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.accessoryType = .DisclosureIndicator
        cell.imageView?.image = UIImage(named: imageName)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        return cell
    }

}
