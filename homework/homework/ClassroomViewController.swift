//
//  ClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SVPullToRefresh
import DZNEmptyDataSet

class ClassroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    struct Constant {
        struct EmptySet {
            static let title = "目前还没有加入任何班级"
            static let description = "尝试下拉刷新以更新班级状态"
        }
        struct ImageName {
            static let emptyDataSet = "classroom"
        }
    }

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let classroomViewModel = ClassroomViewModel()

    var data: [[String: AnyObject]] = []

    var willCreateClassroom = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "ClassroomTableViewCell", bundle: nil), forCellReuseIdentifier: "ClassroomTableViewCell")
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        self.reloadTable()

        self.setupPullToRefresh()

        self.tableView.triggerPullToRefresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if willCreateClassroom {
            self.showSetNameVC()
            willCreateClassroom = false
        }
        self.reloadTable()
    }

    func reloadTable() {
        dispatch_async(dispatch_get_main_queue()) {
            self.data = self.classroomViewModel.getTableViewData()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func actionButtonOnClick(sender: AnyObject) {
        self.showSetNameVC()
    }

    @IBAction func searchButtonOnClick(sender: AnyObject) {

    }
    
    private func showSetNameVC() {
        if let role = UserDefaultsHelper().getRole() {
            if role == "t" {
                let setNameVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetClassroomNameViewController") as! SetClassroomNameViewController
                setNameVC.completeDismissBlock = {(name: String) in
                    self.showCreateClassroomNC(name)
                }
                setNameVC.modalTransitionStyle = .CoverVertical
                self.presentViewController(setNameVC, animated: true, completion: nil)
            } else {
                AlertHelper(viewController: self).showPromptAlertView("当前角色为学生，只有教师才能创建班级")
            }
        }

    }

    private func showCreateClassroomNC(name: String) {
        let createClassroomNC = self.storyboard?.instantiateViewControllerWithIdentifier("CreateClassroomNC") as! UINavigationController
        let createClassroomVC = createClassroomNC.viewControllers[0] as! CreateClassroomViewController
        createClassroomVC.classroomName = name
        createClassroomNC.modalTransitionStyle = .CrossDissolve
        self.presentViewController(createClassroomNC, animated: false, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClassroomTableViewCell") as! ClassroomTableViewCell
        let rowData = self.data[indexPath.row]
        cell.configurate(rowData)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowData = self.data[indexPath.row]
        let classroomUUID: String = rowData[self.classroomKeys.classroomUUID]! as! String
        self.showClassroomDetailVC(classroomUUID)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    private func showClassroomDetailVC(classroomUUID: String) {
        let classroomDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("ClassroomDetailViewController") as! ClassroomDetailViewController
        classroomDetailVC.classroomUUID = classroomUUID
        self.navigationController?.pushViewController(classroomDetailVC, animated: true)
    }

    private func setupPullToRefresh() {
        tableView.addPullToRefreshWithActionHandler {
            APIClassroomGetList(vc: self).run()
        }
        tableView.pullToRefreshView.setTitle("下拉刷新", forState: UInt(SVPullToRefreshStateStopped))
        tableView.pullToRefreshView.setTitle("释放刷新", forState: UInt(SVPullToRefreshStateTriggered))
        tableView.pullToRefreshView.setTitle("正在载入...", forState: UInt(SVPullToRefreshStateLoading))
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let image = UIImage(named: Constant.ImageName.emptyDataSet)
        return image
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = Constant.EmptySet.title
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.grayColor()
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = Constant.EmptySet.description
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = NSTextAlignment.Center
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }

}

