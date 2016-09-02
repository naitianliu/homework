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
            let code = classroom["code"].stringValue
            let classroomName = classroom["name"].stringValue
            let schoolInfo = classroom["school_info"].dictionaryValue
            let schoolName = schoolInfo["name"]?.stringValue
            let classroomUUID = classroom["classroom_uuid"].stringValue
            // get profile image urls
            let members = classroom["members"].arrayValue
            var profileImgURLs: [String] = []
            for member in members {
                let profile = member["profile"].dictionaryValue
                let imgURL = profile["img_url"]!.stringValue
                profileImgURLs.append(imgURL)
            }
            let rowDict: [String: AnyObject] = [
                "classroomName": classroomName,
                "schoolName": schoolName!,
                "classroomUUID": classroomUUID,
                "profileImgURLs": profileImgURLs,
                "code": code
            ]
            dataArray.append(rowDict)
        }
        return dataArray
    }


}