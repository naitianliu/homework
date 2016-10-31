//
//  HomeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Popover
import Toast
import DZNEmptyDataSet
import SVPullToRefresh

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var updatesTableView: UITableView!

    private var popover: Popover!

    typealias CreateClassroomClosureType = () -> Void
    var createClassroomBlock: CreateClassroomClosureType?

    let popoverTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 160, height: 131))
    let popoverMenuData = [
        ["image": "icon-classroom", "title": "创建班级"],
        ["image": "icon-homework", "title": "发布作业"],
        ["image": "icon-qrcode", "title": "扫二维码"]
    ]

    struct Constant {
        struct EmptySet {
            static let title = "暂时还没有任何新的动态"
            static let description = "尝试下拉刷新以获取新的动态"
        }
        struct ImageName {
            static let emptyDataSet = "megaphone"
        }
    }

    var updateDataArray: [[String: AnyObject]] = []
    var currentPage: Int = 0

    let updateViewModel = UpdateViewModel()

    let updateModelHelper = UpdateModelHelper()

    let updateKeys = GlobalKeys.UpdateKeys.self
    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let homeworkKeys = GlobalKeys.HomeworkKeys.self
    let submissionKeys = GlobalKeys.SubmissionKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupPopoverView()

        self.initUpdateTableView()

        self.reloadUpdateTable()

        self.setupPullToRefresh()
        self.setupInfiniteScrolling()

        if let role = UserDefaultsHelper().getRole() {
            self.updatesTableView.triggerPullToRefresh()
            if role == "t" {
                self.initiateAddButton()
            }
        }

        self.navigationItem.title = "动态"
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
        self.reloadUpdateTable()
    }

    func reloadUpdateTable() {
        self.currentPage = 0
        self.updateDataArray = self.updateViewModel.getTableViewData(self.currentPage)
        self.updatesTableView.reloadData()
        self.currentPage = 1
    }

    private func initUpdateTableView() {
        self.updatesTableView.delegate = self
        self.updatesTableView.dataSource = self
        self.updatesTableView.registerNib(UINib(nibName: "UpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "UpdateTableViewCell")
        self.updatesTableView.tableFooterView = UIView()
        self.updatesTableView.estimatedRowHeight = 44
        self.updatesTableView.rowHeight = UITableViewAutomaticDimension
        self.updatesTableView.emptyDataSetSource = self
        self.updatesTableView.emptyDataSetDelegate = self
    }

    private func initiateAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.addButtonOnClick))
        self.navigationItem.rightBarButtonItem = addButton
    }

    func addButtonOnClick(sender: AnyObject) {
        if let role = UserDefaultsHelper().getRole() {
            if role == "t" {
                let popoverOptions: [PopoverOption] = [
                    .Type(.Down),
                    .CornerRadius(0),
                    .SideEdge(0)
                ]
                let startPoint = CGPoint(x: self.view.frame.width - 25, y: 55)
                self.popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
                self.popover.show(popoverTableView, point: startPoint)
            }
        }
    }

    private func setupPopoverView() {
        popoverTableView.delegate = self
        popoverTableView.dataSource = self
        popoverTableView.scrollEnabled = false
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popoverTableView {
            return 3
        } else {
            return self.updateDataArray.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == popoverTableView {
            let rowData = popoverMenuData[indexPath.row]
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = rowData["title"]
            cell.textLabel?.textColor = GlobalConstants.themeColor
            cell.imageView?.image = UIImage(named: rowData["image"]!)
            return cell
        } else {
            let rowData = self.updateDataArray[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("UpdateTableViewCell") as! UpdateTableViewCell
            cell.configurate(rowData)
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == popoverTableView {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            self.popover.dismiss()
            if indexPath.row == 0 {
                self.createClassroomBlock!()
            } else if indexPath.row == 1 {
                PresentVCUtility(vc: self).showSelectHWTypeVC(nil, completion: nil)
            } else if indexPath.row == 2 {

            }
        } else if tableView == updatesTableView {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let rowData = self.updateDataArray[indexPath.row]
            let uuid = rowData[self.updateKeys.uuid] as! String
            self.updateViewModel.markAsRead(uuid)
            let type = rowData[self.updateKeys.type]! as! String
            switch type {
            case self.updateKeys.requests:
                self.showUpdateRequestsVC(rowData)
            case self.updateKeys.homeworks:
                self.showClassroomDetailsVC(rowData)
            case self.updateKeys.submissions:
                self.showHomeworkDetailVC(rowData)
            case self.updateKeys.grades:
                self.showStudentHomeworkDetailViewController(rowData)
            default:
                break
            }
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == updatesTableView {
            return true
        } else {
            return false
        }
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == updatesTableView && editingStyle == .Delete {
            let rowDict = self.updateDataArray[indexPath.row]
            let uuid: String = rowDict["uuid"] as! String
            self.updateModelHelper.delete(uuid)
            self.updateDataArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    private func showUpdateRequestsVC(updateData: [String: AnyObject]) {
        let updateRequestsVC = UpdateRequestViewController(nibName: "UpdateRequestViewController", bundle: nil)
        updateRequestsVC.updateData = updateData
        self.navigationController?.pushViewControllerBottomBarHidden(self, viewController: updateRequestsVC, animated: true)
    }

    private func showClassroomDetailsVC(updateData: [String: AnyObject]) {
        let classroomUUID = updateData[self.classroomKeys.classroomUUID] as! String
        let storyboard = UIStoryboard(name: "Classroom", bundle: nil)
        let classroomDetailVC = storyboard.instantiateViewControllerWithIdentifier("ClassroomDetailViewController") as! ClassroomDetailViewController
        classroomDetailVC.classroomUUID = classroomUUID
        self.navigationController?.pushViewControllerBottomBarHidden(self, viewController: classroomDetailVC, animated: true)
    }

    private func showHomeworkDetailVC(updateData: [String: AnyObject]) {
        let homeworkUUID: String = updateData[self.homeworkKeys.homeworkUUID]! as! String
        let homeworkDetailVC = HomeworkDetailViewController(nibName: "HomeworkDetailViewController", bundle: nil)
        homeworkDetailVC.homeworkUUID = homeworkUUID
        self.navigationController?.pushViewControllerBottomBarHidden(self, viewController: homeworkDetailVC, animated: true)
    }

    private func showStudentHomeworkDetailViewController(updateData: [String: AnyObject]) {
        let studentHWDetailVC = StudentHomeworkDetailViewController(nibName: "StudentHomeworkDetailViewController", bundle: nil)
        let submissionUUID = updateData[self.submissionKeys.submissionUUID]! as! String
        if let submissionInfo = SubmissionModelHelper().getSubmissionInfoByUUID(submissionUUID) {
            let homeworkUUID = submissionInfo[self.submissionKeys.homeworkUUID] as! String
            studentHWDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewControllerBottomBarHidden(self, viewController: studentHWDetailVC, animated: true)
        }
    }

    func showToast(message: String) {
        let style: CSToastStyle = CSToastStyle(defaultStyle: ())
        style.backgroundColor = GlobalConstants.themeColor
        style.messageColor = UIColor.whiteColor()
        self.view.makeToast(message, duration: 3.0, position: CSToastPositionTop, style: style)
    }

    private func setupPullToRefresh() {
        updatesTableView.addPullToRefreshWithActionHandler {
            APIUpdateGet(vc: self).run()
        }
        updatesTableView.pullToRefreshView.setTitle("下拉刷新", forState: UInt(SVPullToRefreshStateStopped))
        updatesTableView.pullToRefreshView.setTitle("释放刷新", forState: UInt(SVPullToRefreshStateTriggered))
        updatesTableView.pullToRefreshView.setTitle("正在载入...", forState: UInt(SVPullToRefreshStateLoading))
    }

    private func setupInfiniteScrolling() {
        self.updatesTableView.addInfiniteScrollingWithActionHandler {
            self.updateDataArray += self.updateViewModel.getTableViewData(self.currentPage)
            self.updatesTableView.reloadData()
            self.currentPage += 1
            self.updatesTableView.infiniteScrollingView.stopAnimating()
        }
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
