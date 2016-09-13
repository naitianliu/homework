//
//  APIClassroomApproveRequest.swift
//  homework
//
//  Created by Liu, Naitian on 9/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class APIClassroomApproveRequest {

    let url = APIURL.classroomApproveRequest

    let role = UserDefaultsHelper().getRole()!

    var vc: UpdateRequestViewController!

    let profileModelHelper = ProfileModelHelper()
    let classroomModelHelper = ClassroomModelHelper()
    let memberModelHelper = MemberModelHelper()

    let profileKeys = GlobalKeys.ProfileKeys.self
    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let updateKeys = GlobalKeys.UpdateKeys.self

    init(vc: UpdateRequestViewController) {
        self.vc = vc
    }

    func run(requestUUID: String, classroomUUID: String, requesterRole: String, requesterProfileInfo: [String: String]) {
        self.showHUD()
        let data: [String: AnyObject] = [
            self.updateKeys.requestUUID: requestUUID,
            "role": role
        ]
        CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
            // success
            self.hideHUD()
            let success = responseData["success"].boolValue
            if success {
                print(requesterProfileInfo)
                let userId = requesterProfileInfo[self.profileKeys.userId]!
                let nickname = requesterProfileInfo[self.profileKeys.nickname]!
                let imgURL = requesterProfileInfo[self.profileKeys.imgURL]!
                self.profileModelHelper.add(userId, nickname: nickname, imgURL: imgURL)
                let memberDict: [String: String] = [
                    self.profileKeys.role: requesterRole,
                    self.profileKeys.userId: userId
                ]
                self.memberModelHelper.addMembers(classroomUUID, members: [memberDict])
                self.vc.navigationController?.popViewControllerAnimated(true)
            } else {
                AlertHelper(viewController: self.vc).showPromptAlertView("已同意该申请")
            }
            }) { (error) in
                // error
                self.hideHUD()
        }
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