//
//  APIClassroomGetList.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIClassroomGetList {

    let url = APIURL.classroomGetList

    let role = UserDefaultsHelper().getRole()!

    let classroomModelHelper = ClassroomModelHelper()

    var vc: ClassroomViewController!

    var newUUIDArray: [String] = []

    init(vc: ClassroomViewController) {
        self.vc = vc
    }

    func run() {
        let data = ["role": "t"]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            let classrooms = responseData["classrooms"].arrayValue
            if errorCode == 0 {
                for classroomData in classrooms {
                    self.addUpdateClassroom(classroomData)
                }
                self.checkConsistence()
                self.vc.reloadTable()
            } else {
                // handle error
            }
            self.vc.tableView.dg_stopLoading()
            }) { (error) in
                // error
                self.vc.tableView.dg_stopLoading()
        }
    }

    private func checkConsistence() {
        let oldUUIDList = self.classroomModelHelper.getUUIDList(true)
        for uuid in oldUUIDList {
            if !self.newUUIDArray.contains(uuid) {
                self.classroomModelHelper.close(uuid)
            }
        }
    }

    private func addUpdateClassroom(classroomData: JSON) {
        let name = classroomData["name"].stringValue
        let code = classroomData["code"].stringValue
        let creator = classroomData["creator"].stringValue
        let introduction = classroomData["introduction"].stringValue
        let schoolUUID = classroomData["school_uuid"].stringValue
        let classroomUUID = classroomData["classroom_uuid"].stringValue
        self.newUUIDArray.append(classroomUUID)
        let active = classroomData["active"].boolValue
        let createdTimestamp = classroomData["created_timestamp"].intValue
        let updatedTimestamp = classroomData["updated_timestamp"].intValue
        var members: [[String: String]] = []
        for item in classroomData["members"].arrayValue {
            let memberJSON = item.dictionaryValue
            let memberDict: [String: String] = [
                "user_id": memberJSON["user_id"]!.stringValue,
                "role": memberJSON["role"]!.stringValue
            ]
            members.append(memberDict)
        }
        self.classroomModelHelper.add(classroomUUID, name:name, introduction: introduction, creator: creator,
                                      schoolUUID: schoolUUID, code: code, active: active, createdTimestamp: createdTimestamp, updatedTimestamp: updatedTimestamp,
                                      members: members)
    }

}