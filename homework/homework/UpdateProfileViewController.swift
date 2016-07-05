//
//  UpdateProfileViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func confirmButtonOnClick(sender: AnyObject) {

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell = tableView.dequeueReusableCellWithIdentifier("ProfileEditTableViewCell") as! ProfileEditTableViewCell
            return cell
        case (1, 0):
            cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "名字"
            if let nickname = UserDefaultsHelper().getNickname() {
                cell.detailTextLabel?.text = nickname
            } else {
                cell.detailTextLabel?.text = "无"
            }
        default:
            cell = UITableViewCell()
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.performSegueWithIdentifier("UpdateAvatarSegue", sender: nil)
        default:
            break
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }


    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

}
