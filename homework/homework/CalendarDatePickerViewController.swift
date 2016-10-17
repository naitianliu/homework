//
//  CalendarDatePickerViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarDatePickerViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendar: FSCalendar!

    var selectedDate: NSDate?

    typealias CompleteSelectionClosureType = (date: NSDate) -> Void
    var completeSelectionBlock: CompleteSelectionClosureType?

    let dateNowCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self

        calendar.appearance.headerTitleColor = GlobalConstants.themeColor
        calendar.appearance.weekdayTextColor = GlobalConstants.themeColor

        if let selectedDate = selectedDate {
            calendar.selectDate(selectedDate)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func completeSelectionBlockSetter(completion: CompleteSelectionClosureType) {
        self.completeSelectionBlock = completion
    }

    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        if let today = calendar.today {
            if date.isEarlierThan(today) {
                AlertHelper(viewController: self).showPromptAlertView("请选择今天以后的日期作为截止日期")
                return
            }
        }
        if let completeSelectionBlock = self.completeSelectionBlock {
            completeSelectionBlock(date: date)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func calendar(calendar: FSCalendar, titleForDate date: NSDate) -> String? {
        if self.dateNowCalendar!.isDateInToday(date) {
            return "今天"
        } else if let selectedDate = selectedDate {
            if selectedDate == date {
                return "截止"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}
