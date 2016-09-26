//
//  APIClassroomUpdate.swift
//  homework
//
//  Created by Liu, Naitian on 9/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class APIClassroomUpdate {

    let url = APIURL.classroomUpdate

    var vc: ClassroomInfoViewController!

    let role: String = UserDefaultsHelper().getRole()!

    let membersModelHelper = MemberModelHelper()

    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self

    init(vc: ClassroomInfoViewController) {
        self.vc = vc
    }

    func updateMembers(classroomUUID: String, teachers: [String], students: [String]) {
        let members = self.getMembers(teachers, students: students)
        let data: [String: AnyObject] = [
            self.classroomKeys.classroomUUID: classroomUUID,
            self.profileKeys.role: role,
            self.classroomKeys.members: members
        ]
        print(data)
        self.showHUD()
        CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
            // success
            self.hideHUD()
            let success = responseData["success"].boolValue
            if success {
                self.updateMembersModel(classroomUUID, members: members)
                self.vc.reloadTable()
            }
            }) { (error) in
                // error
                self.hideHUD()

        }
    }

    private func getMembers(teachers: [String], students: [String]) -> [[String: String]] {
        var members: [[String: String]] = []
        for teacher in teachers {
            let rowDict: [String: String] = [
                self.profileKeys.role: "t",
                self.profileKeys.userId: teacher
            ]
            members.append(rowDict)
        }
        for student in students {
            let rowDict: [String: String] = [
                self.profileKeys.role: "s",
                self.profileKeys.userId: student
            ]
            members.append(rowDict)
        }
        return members
    }

    private func updateMembersModel(classroomUUID: String, members: [[String: String]]) {
        self.membersModelHelper.deleteMembers(classroomUUID)
        self.membersModelHelper.addMembers(classroomUUID, members: members)
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
