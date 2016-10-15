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
        print(NSDate())
        print(date)
        if let completeSelectionBlock = self.completeSelectionBlock {
            completeSelectionBlock(date: date)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

}
