//
//  APIHomeworkGetHomeworkList.swift
//  homework
//
//  Created by Liu, Naitian on 9/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIHomeworkGetHomeworkList {

    let url = APIURL.homeworkGetHomeworkList

    let role: String = UserDefaultsHelper().getRole()!

    let Keys = GlobalKeys.HomeworkKeys.self

    let homeworkModelHelper = HomeworkModelHelper()

    var vc: ClassroomDetailViewController!

    var newUUIDArray: [String] = []

    init(vc: ClassroomDetailViewController) {
        self.vc = vc
    }

    func run(classroomUUID: String) {
        self.showHUD()
        let data = [
            "role": role,
            self.Keys.classroomUUID: classroomUUID
        ]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let homeworks = responseData["homeworks"].arrayValue
                for homework in homeworks {
                    self.addUpdateHomework(homework)
                }
                self.checkConsistence(classroomUUID)
                self.vc.reloadHomeworks()
            }
            }) { (error) in
                // error
                self.hideHUD()

        }

    }

    private func checkConsistence(classroomUUID: String) {
        let oldUUIDList = self.homeworkModelHelper.getUUIDListByClassroom(classroomUUID, active: true)
        for uuid in oldUUIDList {
            if !self.newUUIDArray.contains(uuid) {
                self.homeworkModelHelper.close(uuid)
            }
        }
    }

    private func addUpdateHomework(homeworkJSON: JSON) {
        let infoDict: [String: AnyObject] = homeworkJSON[self.Keys.info].dictionaryObject!
        let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
        let classroomUUID = homeworkJSON[self.Keys.classroomUUID].stringValue
        let creator = homeworkJSON[self.Keys.creator].stringValue
        let active = homeworkJSON[self.Keys.active].boolValue
        let homeworkUUID = homeworkJSON[self.Keys.homeworkUUID].stringValue
        self.newUUIDArray.append(homeworkUUID)
        let createdTimestamp = homeworkJSON[self.Keys.createdTimestamp].intValue
        let updatedTimestamp = homeworkJSON[self.Keys.updatedTimestamp].intValue
        self.homeworkModelHelper.add(homeworkUUID, classroomUUID: classroomUUID, creator: creator, active: active,
                                     createdTimestamp: createdTimestamp, updatedTimestamp: updatedTimestamp,
                                     info: infoData)
    }

    private func showHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        }

    }

    private func hideHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
        }
    }
}