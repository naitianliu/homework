//
//  APIClassroomCreate.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class APIClassroomCreate {

    let url = APIURL.classroomCreate

    var vc: CreateClassroomViewController!

    let role: String = UserDefaultsHelper().getRole()!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    init(vc: CreateClassroomViewController) {
        self.vc = vc
    }

    func run(name: String, schoolUUID: String, introduction: String, members: [[String: String]]?) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        var data: [String: AnyObject] = [
            "role": role,
            "name": name,
            "school_uuid": schoolUUID,
            "introduction": introduction
        ]
        if let members = members {
            data["members"] = members
        }
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // return response
            let errorCode: Int = responseData["error"].intValue
            let timestamp: Int = responseData[self.classroomKeys.timestamp].intValue
            let classroomUUID: String = responseData[self.classroomKeys.classroomUUID].stringValue
            let classroomCode: String = responseData[self.classroomKeys.code].stringValue
            if errorCode == 0 {
                ClassroomModelHelper().add(classroomUUID, name: name, introduction: introduction, creator: nil,
                    schoolUUID: schoolUUID, code: classroomCode, active: true, createdTimestamp: timestamp,
                    updatedTimestamp: timestamp, members: members)
                self.vc.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.showErrorAlert()
            }
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
                self.showErrorAlert()

        }
    }

    private func showErrorAlert() {
        AlertHelper(viewController: self.vc).showPromptAlertView("创建班级失败，请稍后重试")
    }

}
