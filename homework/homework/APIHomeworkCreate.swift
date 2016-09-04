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
import MBProgressHUD

class APIHomeworkCreate {

    let url = APIURL.homeworkCreate

    let role: String = UserDefaultsHelper().getRole()!

    let Keys = GlobalKeys.HomeworkKeys.self

    let homeworkModelHelper = HomeworkModelHelper()

    var vc: UIViewController!
    
    init(vc: UIViewController!) {
        self.vc = vc
    }

    func run(classroomUUID: String, info: [String: AnyObject]) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        let data: [String: AnyObject] = [
            Keys.classroomUUID: classroomUUID,
            "role": role,
            "info": info
        ]
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            let success = responseData["success"].boolValue
            if success {
                let timestamp = responseData["timestamp"].intValue
                let homeworkUUID = responseData[self.Keys.homeworkUUID].stringValue
                let infoData: NSData = NSKeyedArchiver.archivedDataWithRootObject(info)
                self.homeworkModelHelper.add(homeworkUUID, classroomUUID: classroomUUID, creator: nil, active: true, createdTimestamp: timestamp, updatedTimestamp: timestamp, info: infoData)
            }
            self.vc.dismissViewControllerAnimated(true, completion: nil)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
        }
    }
}