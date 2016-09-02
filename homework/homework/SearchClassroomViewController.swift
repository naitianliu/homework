//
//  SearchClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SearchClassroomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!

    var data: [[String: AnyObject]] = []

    var confirmMessageTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.tableFooterView = UIView()

        searchBar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    func reloadTable() {
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let keyword: String = searchBar.text!
        APIClassroomSearch(vc: self).run(keyword)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchClassroomTableViewCell") as! SearchClassroomTableViewCell
        let rowData = self.data[indexPath.row]
        let classroomName: String = rowData["classroomName"]! as! String
        let schoolName: String? = rowData["schoolName"]! as? String
        let profileImgURLs: [String] = rowData["profileImgURLs"]! as! [String]
        cell.configurate(classroomName, schoolName: schoolName, profileImgURLs: profileImgURLs)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowData = self.data[indexPath.row]
        let classroomName: String = rowData["classroomName"]! as! String
        let classroomUUID: String = rowData["classroomUUID"]! as! String
        self.showSendRequestAlert(classroomName, classroomUUID: classroomUUID)

    }

    func showSendRequestAlert(classroomName: String, classroomUUID: String) {
        let alertController = UIAlertController(title: "申请加入班级", message: "班级名称：\(classroomName)", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "验证信息"
            textField.delegate = self
            self.confirmMessageTextField = textField

        }
        alertController.addAction(UIAlertAction(title: "发送申请", style: .Destructive, handler: { (action) in
            // send request
            print(self.confirmMessageTextField?.text)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }

}
