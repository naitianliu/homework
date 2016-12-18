//
//  UpdateViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UpdateViewModel {

    let updateModelHelper = UpdateModelHelper()
    let classroomModelHelper = ClassroomModelHelper()

    let updateKeys = GlobalKeys.UpdateKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self
    let homeworkKeys = GlobalKeys.HomeworkKeys.self
    let submissionKeys = GlobalKeys.SubmissionKeys.self
    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let commentKeys = GlobalKeys.CommentKeys.self

    let dataTypeConversionHelper = DataTypeConversionHelper()

    init() {

    }

    func getTableViewData(page: Int) -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        let updateArray = self.updateModelHelper.getList(page)
        for item in updateArray {
            let type = item[self.updateKeys.type]! as! String
            let uuid = item[self.updateKeys.uuid]! as! String
            let timestamp = item[self.updateKeys.timestamp]! as! Int
            let read = item[self.updateKeys.read]! as! Bool
            let infoData = item[self.updateKeys.info]! as! NSData
            let infoDict: [String: AnyObject] = self.dataTypeConversionHelper.convertNSDataToDict(infoData)
            let infoJSON: JSON = JSON(infoDict)
            switch type {
            case self.updateKeys.requests:
                if let rowDict = self.getRequestRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read) {
                    dataArray.insert(rowDict, atIndex: 0)
                }
            case self.updateKeys.approvals:
                let rowDict = self.getApprovalRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            case self.updateKeys.homeworks:
                let rowDict = self.getHomeworkRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            case self.updateKeys.submissions:
                let rowDict = self.getSubmissionRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            case self.updateKeys.grades:
                let rowDict = self.getGradeRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            case self.updateKeys.comments:
                let rowDict = self.getCommentRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            default:
                break
            }
        }
        return dataArray
    }

    func getRequestRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject]? {
        let classroomUUID = info[self.classroomKeys.classroomUUID].stringValue
        if let classroomInfo = self.classroomModelHelper.getClassroomInfo(classroomUUID) {
            let classroomName = classroomInfo[self.classroomKeys.classroomName]! as! String
            let requestUUID = info[self.updateKeys.requestUUID].stringValue
            let requesterRole = info[self.updateKeys.requesterRole].stringValue
            let requesterProfile = info[self.updateKeys.requesterProfile]
            let nickname = requesterProfile[self.profileKeys.nickname].stringValue
            let imgURL = requesterProfile[self.profileKeys.imgURL].stringValue
            let title = "\(nickname)申请加入班级"
            let subtitle = "班级名称：\(classroomName)"
            let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
            guard let requesterProfileDict = requesterProfile.dictionaryObject else { return nil }
            let rowDict: [String: AnyObject] = [
                self.updateKeys.type: type,
                self.updateKeys.uuid: uuid,
                self.updateKeys.imgURL: imgURL,
                self.updateKeys.title: title,
                self.updateKeys.subtitle: subtitle,
                self.updateKeys.requesterRole: requesterRole,
                self.updateKeys.requesterProfile: requesterProfileDict as! [String: String],
                self.updateKeys.timeString: timeString,
                self.updateKeys.read: read,
                self.updateKeys.requestUUID: requestUUID,
                self.classroomKeys.classroomUUID: classroomUUID
            ]
            return rowDict
        } else {
            return nil
        }

    }

    func getApprovalRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let classroomUUID = info[self.classroomKeys.classroomUUID].stringValue
        let classroomName = info[self.classroomKeys.classroomName].stringValue
        let approverProfileInfo = info[self.updateKeys.approverProfileInfo]
        // let nickname = approverProfileInfo[self.profileKeys.nickname].stringValue
        let imgURL = approverProfileInfo[self.profileKeys.imgURL].stringValue
        let title = "已被加入班级"
        let subtitle = "班级名称：\(classroomName)"
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.updateKeys.imgURL: imgURL,
            self.classroomKeys.classroomUUID: classroomUUID,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read,
        ]
        return rowDict
    }

    func getHomeworkRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let classroomUUID = info[self.classroomKeys.classroomUUID].stringValue
        let classroomName = info[self.classroomKeys.classroomName].stringValue
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let title = "收到新的作业"
        let subtitle = "来自于班级：\(classroomName)"
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.classroomKeys.classroomUUID: classroomUUID,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read,
            ]
        return rowDict
    }

    func getSubmissionRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let homeworkUUID = info[self.homeworkKeys.homeworkUUID].stringValue
        let studentNickname = info[self.updateKeys.studentNickname].stringValue
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let title = "收到作业提交"
        let subtitle = "学生：\(studentNickname)"
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.homeworkKeys.homeworkUUID: homeworkUUID,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read,
            ]
        return rowDict
    }

    func getGradeRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let submissionUUID = info[self.submissionKeys.submissionUUID].stringValue
        let score = info[self.submissionKeys.score].stringValue
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let title = "作业已批改"
        let subtitle = "分数：\(score)"
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.submissionKeys.submissionUUID: submissionUUID,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read,
            ]
        return rowDict
    }

    func getCommentRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let homeworkUUID = info[self.submissionKeys.homeworkUUID].stringValue
        let submissionUUID = info[self.submissionKeys.submissionUUID].stringValue
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let text = info[self.updateKeys.info][self.commentKeys.text].stringValue
        let authorProfileInfo = info[self.updateKeys.authorProfileInfo]
        let nickname = authorProfileInfo[self.profileKeys.nickname].stringValue
        let imgURL = authorProfileInfo[self.profileKeys.imgURL].stringValue
        let title = "来自 \(nickname) 的评论"
        let subtitle = "\(text)"
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.submissionKeys.submissionUUID: submissionUUID,
            self.submissionKeys.homeworkUUID: homeworkUUID,
            self.profileKeys.imgURL: imgURL,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read
        ]
        return rowDict
    }

    func markAsRead(uuid: String) {
        self.updateModelHelper.markAsRead(uuid)
    }

}
