//
//  APIClassroomSendRequest.swift
//  homework
//
//  Created by Liu, Naitian on 9/11/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class APIClassroomSendRequest {

    let url = APIURL.classroomSendRequest

    let role = UserDefaultsHelper().getRole()!

    var vc: SearchClassroomViewController!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    init(vc: SearchClassroomViewController) {
        self.vc = vc
    }

    func run(classroomUUID: String, comment: String?) {
        self.showHUD()
        var data: [String: AnyObject] = [
            self.classroomKeys.classroomUUID: classroomUUID,
            "role": role
        ]
        if let comment = comment {
            data["comment"] = comment
        }
        CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                self.vc.showRequestSentToast()
            }
            }) { (error) in
                // error
                self.hideHUD()
                AlertHelper(viewController: self.vc).showPromptAlertView("加入申请发送失败，请稍候重试")
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