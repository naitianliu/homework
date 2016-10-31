//
//  APIHomeworkCreate.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIHomeworkCreate {

    let url = APIURL.homeworkCreate

    let role: String = UserDefaultsHelper().getRole()!

    let Keys = GlobalKeys.HomeworkKeys.self

    let homeworkModelHelper = HomeworkModelHelper()

    var vc: CreateHWViewController!
    
    init(vc: CreateHWViewController!) {
        self.vc = vc
    }

    func run(classroomUUID: String, dueDateTimestamp: Int, info: [String: AnyObject]) {
        let data: [String: AnyObject] = [
            Keys.classroomUUID: classroomUUID,
            "role": role,
            "info": info
        ]
        let hud = ProgressHUDHelper(view: self.vc.view)
        hud.show()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            hud.hide()
            let success = responseData["success"].boolValue
            if success {
                let timestamp = responseData["timestamp"].intValue
                let homeworkUUID = responseData[self.Keys.homeworkUUID].stringValue
                let infoData: NSData = DataTypeConversionHelper().convertDictToNSData(info)
                self.homeworkModelHelper.add(homeworkUUID, classroomUUID: classroomUUID, creator: nil, active: true, dueDateTimestamp: dueDateTimestamp, createdTimestamp: timestamp, updatedTimestamp: timestamp, info: infoData)
            }
            self.vc.dismissViewControllerAnimated(true, completion: {
                if let completion = self.vc.completionBlock {
                    completion()
                }
            })
            }) { (error) in
                // error
                hud.hide()
        }
    }
}