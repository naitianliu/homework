//
//  ClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ClassroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    let classroomViewModel = ClassroomViewModel()

    var data: [[String: AnyObject]] = []

    var willCreateClassroom = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.reloadTable()

        self.setupPullToRefresh()

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
        self.data = self.classroomViewModel.getTableViewData()
        self.tableView.reloadData()
    }
    
    @IBAction func actionButtonOnClick(sender: AnyObject) {
        self.showSetNameVC()
    }

    @IBAction func searchButtonOnClick(sender: AnyObject) {

    }
    
    private func showSetNameVC() {
        let setNameVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetClassroomNameViewController") as! SetClassroomNameViewController
        setNameVC.completeDismissBlock = {(name: String) in
            self.showCreateClassroomNC(name)
        }
        setNameVC.modalTransitionStyle = .CoverVertical
        self.presentViewController(setNameVC, animated: true, completion: nil)
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
        let classroomName: String = rowData["classroomName"]! as! String
        let schoolName: String? = rowData["schoolName"]! as? String
        let profileImgURLs: [String] = rowData["profileImgURLs"]! as! [String]
        let studentNumber: String = rowData["studentNumber"]! as! String
        cell.configurate(classroomName, schoolName: schoolName, profileImgURLs: profileImgURLs, studentNumber: studentNumber)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let classroomDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("ClassroomDetailViewController") as! ClassroomDetailViewController
        self.navigationController?.pushViewController(classroomDetailVC, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    private func setupPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({
            // api call to get list
            APIClassroomGetList(vc: self).run()
            // stop loading
            self.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(GlobalConstants.themeColor)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    deinit {
        tableView.dg_removePullToRefresh()
    }

}

