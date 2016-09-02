//
//  HomeworkCommentViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomeworkCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var audioDuration: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerNib(UINib(nibName: "EditTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "EditTextViewTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.keyboardDismissMode = .OnDrag

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
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.placeholder = "编辑评论内容"
            cell.configurate({ (text) in
                print(text)
            })
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
            cell.configurate(audioDuration)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

}
