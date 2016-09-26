//
//  QAAnswerViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SVPullToRefresh
import Toast

class QAAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var questionData: [String: AnyObject]!

    var tableData: [[String: AnyObject]] = []
    var pageNumber: Int = 1
    var scrollToBottom: Bool = false

    var questionUUID: String!

    let qaKeys = GlobalKeys.QAKeys.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()
        self.setupInfiniteScrolling()

        self.questionUUID = self.questionData[self.qaKeys.questionUUID] as! String

        self.initiateLoadData()

        self.navigationItem.title = "问题回答"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.initiateLoadData()
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "QuestionActionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionActionTableViewCell")
        tableView.registerNib(UINib(nibName: "QAAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "QAAnswerTableViewCell")
    }

    private func initiateLoadData() {
        self.scrollToBottom = false
        self.pageNumber = 1
        let hudHelper = ProgressHUDHelper(view: self.view)
        APIQAAnswerGetList().run(self.questionUUID, pageNumber: self.pageNumber, beginBlock: {
            hudHelper.show()
            }, completeBlock: { (dataArray) in
                hudHelper.hide()
                self.tableData = dataArray
                self.reloadTable()
            }, errorBlock: {
                // error
                hudHelper.hide()
        })
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.tableData.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("QuestionActionTableViewCell") as! QuestionActionTableViewCell
            cell.configurate(self.questionData, addAnswerClicked: { 
                // create answer button clicked
                self.showQAAnswerCreateVC()
            })
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("QAAnswerTableViewCell") as! QAAnswerTableViewCell
            let rowDict = self.tableData[indexPath.row]
            cell.configurate(rowDict)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "当前问题"
        case 1:
            return "全部回答"
        default:
            return nil
        }
    }

    private func showQAAnswerCreateVC() {
        let qaAnswerCreateVC = QAAnswerCreateViewController(nibName: "QAAnswerCreateViewController", bundle: nil)
        let questionUUID = self.questionData[self.qaKeys.questionUUID] as! String
        qaAnswerCreateVC.questionUUID = questionUUID
        self.navigationController?.pushViewController(qaAnswerCreateVC, animated: true)
    }

    private func setupInfiniteScrolling() {
        self.tableView.addInfiniteScrollingWithActionHandler {
            if self.scrollToBottom {
                self.tableView.infiniteScrollingView.stopAnimating()
            } else {
                self.pageNumber += 1
                APIQAAnswerGetList().run(self.questionUUID, pageNumber: self.pageNumber, beginBlock: {
                    // begin
                    }, completeBlock: { (dataArray) in
                        // complete
                        if dataArray.count == 0 {
                            self.scrollToBottom = true
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

}
