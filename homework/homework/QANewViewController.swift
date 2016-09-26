//
//  QANewViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SVPullToRefresh
import Toast

class QANewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData: [[String: AnyObject]] = []
    var pageNumber: Int = 1
    var scrollToBottom: Bool = false

    var filterType: String!

    var parentVC: QAViewController!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupPullToRefresh()
        self.setupInfiniteScrolling()
        self.initTableView()

        self.tableView.triggerPullToRefresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionTableViewCell") as! QuestionTableViewCell
        let rowDict = self.tableData[indexPath.row]
        cell.configurate(rowDict) { (questionUUID) in
            self.showQAAnswerCreateVC(questionUUID)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let questionData = self.tableData[indexPath.row]
        let qaAnswerVC = QAAnswerViewController(nibName: "QAAnswerViewController", bundle: nil)
        qaAnswerVC.questionData = questionData
        self.parentVC.navigationController?.pushViewController(qaAnswerVC, animated: true)
    }

    private func showScrollToButtonToast() {
        let style: CSToastStyle = CSToastStyle(defaultStyle: ())
        style.backgroundColor = GlobalConstants.themeColor
        style.messageColor = UIColor.whiteColor()
        self.view.makeToast("没有更多的问题了", duration: 2.0, position: CSToastPositionCenter, style: style)
    }

    private func showQAAnswerCreateVC(questionUUID: String) {
        let qaAnswerCreateVC = QAAnswerCreateViewController(nibName: "QAAnswerCreateViewController", bundle: nil)
        qaAnswerCreateVC.questionUUID = questionUUID
        self.parentVC.navigationController?.pushViewController(qaAnswerCreateVC, animated: true)
    }

    private func setupInfiniteScrolling() {
        self.tableView.addInfiniteScrollingWithActionHandler {
            if self.scrollToBottom {
                self.showScrollToButtonToast()
                self.tableView.infiniteScrollingView.stopAnimating()
            } else {
                self.pageNumber += 1
                APIQAQuestionGetList().run(self.filterType, pageNumber: self.pageNumber, beginBlock: {
                    // begin
                    }, completeBlock: { (dataArray) in
                        // complete
                        if dataArray.count == 0 {
                            self.scrollToBottom = true
                            self.showScrollToButtonToast()
                        } else {
                            self.tableData = self.tableData + dataArray
                            self.reloadTable()
                        }
                        self.tableView.infiniteScrollingView.stopAnimating()
                    }, errorBlock: {
                        // error
                        self.tableView.infiniteScrollingView.stopAnimating()
                })
            }

        }
    }

    private func setupPullToRefresh() {
        /*
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = GlobalConstants.themeColor
        tableView.dg_addPullToRefreshWithActionHandler({
            // api call to get list
            self.scrollToBottom = false
            self.pageNumber = 1
            APIQAQuestionGetList().run(self.pageNumber, beginBlock: { 
                // begin
                }, completeBlock: { (dataArray) in
                    // complete
                    self.tableData = dataArray
                    self.reloadTable()
                    self.tableView.dg_stopLoading()
                }, errorBlock: { 
                    // error
                    self.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.whiteColor())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        */
        tableView.addPullToRefreshWithActionHandler { 
            self.scrollToBottom = false
            self.pageNumber = 1
            APIQAQuestionGetList().run(self.filterType, pageNumber: self.pageNumber, beginBlock: {
                // begin
                }, completeBlock: { (dataArray) in
                    // complete
                    self.tableData = dataArray
                    self.reloadTable()
                    self.tableView.pullToRefreshView.stopAnimating()
                }, errorBlock: {
                    // error
                    self.tableView.pullToRefreshView.stopAnimating()
            })
        }
        tableView.pullToRefreshView.setTitle("下拉刷新", forState: UInt(SVPullToRefreshStateStopped))
        tableView.pullToRefreshView.setTitle("释放刷新", forState: UInt(SVPullToRefreshStateTriggered))
        tableView.pullToRefreshView.setTitle("正在载入...", forState: UInt(SVPullToRefreshStateLoading))
    }

    deinit {
        tableView.dg_removePullToRefresh()
    }
}
