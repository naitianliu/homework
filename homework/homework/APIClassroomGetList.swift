//
//  APIClassroomGetList.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class APIClassroomGetList {

    let url = APIURL.classroomGetList

    let role = UserDefaultsHelper().getRole()!

    var vc: ClassroomViewController!

    init(vc: ClassroomViewController) {
        self.vc = vc
    }

    func run() {
        let data = ["role": "t"]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let name = responseData["name"].stringValue
                let code = responseData["code"].stringValue
                let creator = responseData["creator"].stringValue
                let introduction = responseData["introduction"].stringValue
                let schoolUUID = responseData["school_uuid"].stringValue
                let classroomUUID = responseData["classroom_uuid"].stringValue
                let active = responseData["active"].boolValue
                let createdTimestamp = responseData["created_timestamp"].intValue
                let updatedTimestamp = responseData["updated_timestamp"].intValue
                var members: [[String: String]] = []
                for item in responseData["members"].arrayValue {
                    let memberJSON = item.dictionaryValue
                    let memberDict: [String: String] = [
                        "user_id": memberJSON["user_id"]!.stringValue,
                        "t": memberJSON["t"]!.stringValue
                    ]
                    members.append(memberDict)
                }
                ClassroomModelHelper().add(classroomUUID, name:name, introduction: introduction, creator: creator,
                    schoolUUID: schoolUUID, code: code, active: active, createdTimestamp: createdTimestamp, updatedTimestamp: updatedTimestamp,
                    members: members)
                self.vc.reloadTable()
            } else {
                self.vc.tableView.dg_stopLoading()
            }
            }) { (error) in
                // error
                self.vc.tableView.dg_stopLoading()
        }
    }

}