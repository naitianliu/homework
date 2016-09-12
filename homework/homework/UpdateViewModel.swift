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
    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let dataTypeConversionHelper = DataTypeConversionHelper()

    init() {

    }

    func getTableViewData() -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        let updateArray = self.updateModelHelper.getList()
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
                let rowDict = self.getRequestRowDict(uuid, type: type, timestamp: timestamp, info: infoJSON, read: read)
                dataArray.insert(rowDict, atIndex: 0)
            default:
                break
            }
        }
        return dataArray
    }

    func getRequestRowDict(uuid: String, type: String, timestamp: Int, info: JSON, read: Bool) -> [String: AnyObject] {
        let classroomUUID = info[self.classroomKeys.classroomUUID].stringValue
        let classroomInfo = self.classroomModelHelper.getClassroomInfo(classroomUUID)!
        let classroomName = classroomInfo[self.classroomKeys.classroomName]! as! String
        let requestUUID = info[self.updateKeys.requestUUID].stringValue
        let requesterProfile = info[self.updateKeys.requesterProfile]
        let nickname = requesterProfile[self.profileKeys.nickname].stringValue
        let imgURL = requesterProfile[self.profileKeys.imgURL].stringValue
        let title = "\(nickname) 申请加入班级"
        let subtitle = "班级名称：\(classroomName)"
        let timeString = DateUtility().convertEpochToHumanFriendlyString(timestamp)
        let rowDict: [String: AnyObject] = [
            self.updateKeys.type: type,
            self.updateKeys.uuid: uuid,
            self.updateKeys.imgURL: imgURL,
            self.updateKeys.title: title,
            self.updateKeys.subtitle: subtitle,
            self.updateKeys.timeString: timeString,
            self.updateKeys.read: read,
            self.updateKeys.requestUUID: requestUUID,
            self.classroomKeys.classroomUUID: classroomUUID
        ]
        return rowDict
    }

    func markAsRead(uuid: String) {
        self.updateModelHelper.markAsRead(uuid)
    }

}