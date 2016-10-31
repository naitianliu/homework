//
//  HomeworkViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeworkViewModel {

    let homeworkModelHelper = HomeworkModelHelper()
    let profileModelHelper = ProfileModelHelper()

    let homeworkKeys = GlobalKeys.HomeworkKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self
    let submissionKeys = GlobalKeys.SubmissionKeys.self

    let dateUtility = DateUtility()

    init() {

    }

    func getCurrentHomeworksData(classroomUUID: String) -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        let homeworks: [[String: AnyObject]] = self.homeworkModelHelper.getListByClassroom(classroomUUID, active: true)
        for homework in homeworks {
            let rowDict = self.getRowDictByHomework(homework)
            dataArray.append(rowDict)
        }
        return dataArray
    }

    func getAllHomeworkList(classroomUUID: String) -> ([[String: AnyObject]], [[String: AnyObject]]) {
        var openArray: [[String: AnyObject]] = []
        var closedArray: [[String: AnyObject]] = []
        for homework in self.homeworkModelHelper.getListByClassroom(classroomUUID, active: true) {
            let rowDict = self.getRowDictByHomework(homework)
            openArray.append(rowDict)
        }
        for homework in self.homeworkModelHelper.getListByClassroom(classroomUUID, active: false) {
            let rowDict = self.getRowDictByHomework(homework)
            closedArray.append(rowDict)
        }
        return (openArray, closedArray)
    }

    func getHomeworkInfo(homeworkUUID: String) -> [String: AnyObject] {
        let homeworkDict = self.homeworkModelHelper.getHomewworkInfoByHomeworkUUID(homeworkUUID)
        let rowDict = self.getRowDictByHomework(homeworkDict!)
        return rowDict
    }

    private func getRowDictByHomework(homework: [String: AnyObject]) -> [String: AnyObject] {
        // homework uuid
        let homeworkUUID: String = homework[self.homeworkKeys.homeworkUUID]! as! String
        // time
        let createdTimestamp: Int = homework[self.homeworkKeys.createdTimestamp]! as! Int
        let createdTimeString: String = self.dateUtility.convertEpochToHumanFriendlyString(createdTimestamp)
        // teacher
        let creator: String = homework[self.homeworkKeys.creator]! as! String
        let teacherInfoTup = self.getTeacherInfoByUserId(creator)
        // info
        let infoData: NSData = homework[self.homeworkKeys.info] as! NSData
        let infoDict = DataTypeConversionHelper().convertNSDataToDict(infoData)
        let infoJSON = JSON(infoDict)
        let content = infoJSON[self.homeworkKeys.content].stringValue
        let type = infoJSON[self.homeworkKeys.type].stringValue
        // due date
        // let dueDateTimestamp = infoJSON[self.homeworkKeys.dueDateTimestamp].intValue
        let dueDateTimestamp = homework[self.homeworkKeys.dueDateTimestamp]! as! Int
        let dueDate: NSDate = self.dateUtility.convertEpochToDate(dueDateTimestamp)
        let dueDateString = self.dateUtility.convertUTCDateToHumanFriendlyDateString(dueDate)
        var rowDict: [String: AnyObject] = [
            self.homeworkKeys.homeworkUUID: homeworkUUID,
            self.homeworkKeys.teacherImgURL: teacherInfoTup.1,
            self.homeworkKeys.teacherName: teacherInfoTup.0,
            self.homeworkKeys.type: type,
            self.homeworkKeys.content: content,
            self.homeworkKeys.dueDateString: dueDateString,
            self.homeworkKeys.createdTimeString: createdTimeString
        ]
        if let audioList = infoJSON[self.submissionKeys.audioList].arrayObject {
            rowDict[self.submissionKeys.audioList] = audioList
        }
        if let imageURLs = infoJSON[self.submissionKeys.imageURLList].arrayObject {
            rowDict[self.submissionKeys.imageURLList] = imageURLs
        }
        return rowDict
    }

    private func getTeacherInfoByUserId(userId: String) -> (String, String) {
        var teacherName = "未知"
        var teacherImgURL = ""
        if let profileInfo = self.profileModelHelper.getProfileInfo(userId) {
            teacherName = profileInfo[self.profileKeys.nickname]!
            teacherImgURL = profileInfo[self.profileKeys.imgURL]!
        }
        return (teacherName, teacherImgURL)
    }

    func getDateCountDictByMonth(classroomUUID: String, month: NSDate) -> [NSDate: Int] {
        var resultDict: [NSDate: Int] = [:]
        let dateUtility = DateUtility()
        for i in -7...38 {
            let date = month.dateByAddingDays(i)
            let from: Int = dateUtility.convertDateToEpoch(date)
            let to: Int = dateUtility.convertDateToEpoch(date.dateByAddingDays(1))
            let count = self.homeworkModelHelper.getHomeworkCountByDateRange(classroomUUID, from: from, to: to, active: true)
            resultDict[date] = count
        }
        return resultDict
    }

    func getHomeworkListByDueDate(classroomUUID: String, dueDate: NSDate) -> [[String: AnyObject]] {
        let from: Int = dateUtility.convertDateToEpoch(dueDate)
        let to: Int = dateUtility.convertDateToEpoch(dueDate.dateByAddingDays(1))
        var dataArray: [[String: AnyObject]] = []
        for homework in self.homeworkModelHelper.getHomeworkListByDateRange(classroomUUID, from: from, to: to, active: true) {
            let rowDict = self.getRowDictByHomework(homework)
            dataArray.append(rowDict)
        }
        return dataArray
    }

}


