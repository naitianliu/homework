//
//  APIClassroomSearch.swift
//  homework
//
//  Created by Liu, Naitian on 8/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIClassroomSearch {

    let url = APIURL.classroomSearch
    let role = UserDefaultsHelper().getRole()!

    var vc: SearchClassroomViewController!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    init(vc: SearchClassroomViewController) {
        self.vc = vc
    }

    func run(keyword: String) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        let data = ["role": role, "keyword": keyword]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let dataArray = self.getTableData(responseData)
                self.vc.data = dataArray
                self.vc.reloadTable()
            } else {
                // handle error
            }
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
        }
    }

    func getTableData(responseData: JSON) -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        let classrooms = responseData["classrooms"].arrayValue
        for classroom in classrooms {
            let code = classroom[self.classroomKeys.code].stringValue
            let classroomName = classroom[self.classroomKeys.classroomName].stringValue
            let schoolInfo = classroom[self.classroomKeys.schoolInfo]
            let schoolName = schoolInfo[self.classroomKeys.schoolName].stringValue
            let classroomUUID = classroom[self.classroomKeys.classroomUUID].stringValue
            // get profile image urls
            let members = classroom["members"].arrayValue
            var teacherProfiles: [[String: String]] = []
            for member in members {
                let role = member["role"].stringValue
                if role == "t" {
                    let profile = member["profile"].dictionaryObject as! [String: String]
                    teacherProfiles.append(profile)
                }
            }
            let rowDict: [String: AnyObject] = [
                self.classroomKeys.classroomName: classroomName,
                self.classroomKeys.schoolName: schoolName,
                self.classroomKeys.classroomUUID: classroomUUID,
                self.classroomKeys.teacherProfiles: teacherProfiles,
                self.classroomKeys.code: code
            ]
            dataArray.append(rowDict)
        }
        return dataArray
    }


}