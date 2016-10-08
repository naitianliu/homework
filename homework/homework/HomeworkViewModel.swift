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
        let dueDateTimestamp = infoJSON[self.homeworkKeys.dueDateTimestamp].intValue
        let dueDate: NSDate = self.dateUtility.convertEpochToDate(dueDateTimestamp)
        let dueDateString = self.dateUtility.convertUTCDateToHumanFriendlyDateString(dueDate)
        let rowDict: [String: AnyObject] = [
            self.homeworkKeys.homeworkUUID: homeworkUUID,
            self.homeworkKeys.teacherImgURL: teacherInfoTup.1,
            self.homeworkKeys.teacherName: teacherInfoTup.0,
            self.homeworkKeys.type: type,
            self.homeworkKeys.content: content,
            self.homeworkKeys.dueDateString: dueDateString,
            self.homeworkKeys.createdTimeString: createdTimeString
        ]
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

}