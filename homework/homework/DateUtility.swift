//
//  DateUtility.swift
//  homework
//
//  Created by Liu, Naitian on 6/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import DateTools

class DateUtility {
    init() {
        
    }
    
    func convertTimeIntervalToHumanFriendlyTime(time: NSTimeInterval) -> String {
        let ti = NSInteger(time)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = ti / 3600
        var humanFriendlyTime: NSString!
        if hours == 0 {
            humanFriendlyTime = NSString(format: "%0.2d:%0.2d", minutes, seconds)
        } else {
            humanFriendlyTime = NSString(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }
        return humanFriendlyTime as String
    }
    
    func getCurrentEpochTime() -> Int {
        let time = NSDate()
        let epoch = self.convertDateToEpoch(time)
        return epoch
    }
    
    func convertDateToEpoch(date: NSDate) -> Int {
        let epoch: Int = Int(date.timeIntervalSince1970)
        return epoch
    }
    
    func convertEpochToDate(epoch: Int) -> NSDate {
        if epoch == 0 {
            let date: NSDate = NSDate()
            return date
        } else {
            let date: NSDate = NSDate(timeIntervalSince1970: NSTimeInterval(epoch))
            return date
        }
    }
    
    func getDateEndOfToday() -> NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        let endOfToday = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.getDateStartOfToday(), options: NSCalendarOptions())
        return endOfToday!
    }
    
    func convertEpochToHumanFriendlyString(epoch: Int) -> String {
        let date: NSDate = self.convertEpochToDate(epoch)
        var result: String = ""
        if date.isLaterThanOrEqualTo(self.getDateStartOfToday()) {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            result = formatter.stringFromDate(date)
        } else if date.isLaterThanOrEqualTo(self.getDateStartOfYesterday()) {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            result = formatter.stringFromDate(date)
            result = "昨天 \(result)"
        } else if date.isLaterThanOrEqualTo(self.getDateStartOfOneWeekAgo()) {
            let timeAgo = date.shortTimeAgoSinceNow()
            result = "\(timeAgo.characters.first!)天前"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM月dd日"
            result = formatter.stringFromDate(date)
        }
        return result
    }
    
    func convertTZToEpoch(tzString: String) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let date = dateFormatter.dateFromString(tzString)!
        let epoch = self.convertDateToEpoch(date)
        return epoch
    }

    func convertUTCDateToHumanFriendlyDateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }

    private func getDateStartOfToday() -> NSDate {
        let startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        return startOfToday
    }

    private func getDateStartOfYesterday() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])!
        return date
    }

    private func getDateStartOfOneWeekAgo() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: -7, toDate: NSDate(), options: [])!
        return date
    }
}

