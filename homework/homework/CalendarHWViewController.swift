//
//  CalendarHWViewController.swift
//  homework
//
//  Created by Liu, Naitian on 10/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import FSCalendar
import DZNEmptyDataSet

class CalendarHWViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!

    var tableData: [[String: AnyObject]] = []

    var classroomUUID: String!

    var dateCountDict: [NSDate: Int] = [:]

    let homeworkViewModel = HomeworkViewModel()

    let role = UserDefaultsHelper().getRole()!

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()
        self.initCalendar()

        self.navigationItem.title = "作业日历"
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")
    }

    private func initCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerTitleColor = GlobalConstants.themeColor
        calendar.appearance.weekdayTextColor = GlobalConstants.themeColor
        // load count this month
        let currentMonth: NSDate = calendar.currentMonth
        self.dateCountDict = self.homeworkViewModel.getDateCountDictByMonth(classroomUUID, month: currentMonth)
        // load table due today
        if let today = calendar.today {
            self.tableData = self.homeworkViewModel.getHomeworkListByDueDate(classroomUUID, dueDate: today)
        }
    }

    private func renderTableHeaderView() {

    }

    func reloadTable() {
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
        let rowDict = self.tableData[indexPath.row]
        cell.configurate(rowDict)
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "当天截止作业"
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowDict = self.tableData[indexPath.row]
        let homeworkUUID: String = rowDict[self.homeworkKeys.homeworkUUID]! as! String
        self.showHomeworkDetailVC(homeworkUUID)
    }

    private func showHomeworkDetailVC(homeworkUUID: String) {
        if self.role == "t" {
            let homeworkDetailVC = HomeworkDetailViewController(nibName: "HomeworkDetailViewController", bundle: nil)
            homeworkDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewController(homeworkDetailVC, animated: true)
        } else if self.role == "s" {
            let studentHWDetailVC = StudentHomeworkDetailViewController(nibName: "StudentHomeworkDetailViewController", bundle: nil)
            studentHWDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewController(studentHWDetailVC, animated: true)
        }

    }

    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        self.tableData = self.homeworkViewModel.getHomeworkListByDueDate(classroomUUID, dueDate: date)
        self.reloadTable()
    }

    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        if let number = self.dateCountDict[date] {
            return number
        } else {
            return 0
        }
    }

    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
        let currentMonth: NSDate = calendar.currentMonth
        self.dateCountDict = self.homeworkViewModel.getDateCountDictByMonth(classroomUUID, month: currentMonth)
        calendar.reloadData()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "当天没有截止作业"
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(17),
            NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }

}
