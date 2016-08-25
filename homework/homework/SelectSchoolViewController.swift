//
//  SelectSchoolViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SelectSchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    struct Constant {
        struct EmptySet {
            static let title = "还没有添加任何学校或机构"
            static let description = "点击添加按钮，添加您的学校或机构"
        }
    }
    typealias CompleteSelectionClosureType = (id: String, name: String) -> Void

    @IBOutlet weak var tableView: UITableView!

    var completeSelectionBlock: CompleteSelectionClosureType?

    var data: [[String: String?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self

        self.reloadTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    private func reloadTable() {
        data = SchoolModelHelper().getAll()
        tableView.reloadData()
    }

    @IBAction func addButtonOnClick(sender: AnyObject) {
        self.showAddSchoolNC()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func completeSelectionBlockSetter(completion: CompleteSelectionClosureType) {
        self.completeSelectionBlock = completion
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SchoolTableViewCell") as! SchoolTableViewCell
        let rowDict = data[indexPath.row]
        let name = rowDict["name"]!!
        let address = rowDict["address"]!
        cell.configurate(name, address: address)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowDict = data[indexPath.row]
        let schoolUUID: String = rowDict["uuid"]!!
        let schoolName: String = rowDict["name"]!!
        self.navigationController?.popViewControllerWithCompletion(true, complete: { 
            self.completeSelectionBlock!(id: schoolUUID, name: schoolName)
        })
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
            NSFontAttributeName: UIFont.boldSystemFontOfSize(15),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }

    private func showAddSchoolNC() {
        let addSchoolNC = self.storyboard?.instantiateViewControllerWithIdentifier("AddSchoolNC") as! UINavigationController
        addSchoolNC.modalTransitionStyle = .CoverVertical
        self.presentViewController(addSchoolNC, animated: true, completion: nil)
    }

}
