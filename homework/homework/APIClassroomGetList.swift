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

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    var vc: ClassroomViewController!

    var newUUIDArray: [String] = []

    init(vc: ClassroomViewController) {
        self.vc = vc
    }

    func run() {
        let data = ["role": role]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            let classrooms = responseData["classrooms"].arrayValue
            if errorCode == 0 {
                for classroomData in classrooms {
                    let classroomUUID = classroomData[self.classroomKeys.classroomUUID].stringValue
                    self.newUUIDArray.append(classroomUUID)
                    self.classroomModelHelper.addUpdateClassroom(classroomData)
                }
                self.checkConsistence()
                self.vc.reloadTable()
            } else {
                // handle error
            }
            self.vc.tableView.pullToRefreshView.stopAnimating()
            }) { (error) in
                // error
                self.vc.tableView.pullToRefreshView.stopAnimating()
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

}