//
//  APIClassroomClose.swift
//  homework
//
//  Created by Liu, Naitian on 10/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class APIClassroomClose {

    let url = APIURL.classroomClose

    var vc: ClassroomInfoViewController!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let classroomModelHelper = ClassroomModelHelper()

    let role = UserDefaultsHelper().getRole()!

    typealias CompleteClosureType = () -> Void

    init(vc: ClassroomInfoViewController) {
        self.vc = vc
    }

    func run(classroomUUID: String, completion: CompleteClosureType) {
        let data: [String: AnyObject] = [
            self.classroomKeys.classroomUUID: classroomUUID,
            "role": role
        ]
        let hud = ProgressHUDHelper(view: self.vc.view)
        hud.show()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            let success = responseData["success"].boolValue
            if success {
                self.classroomModelHelper.close(classroomUUID)
                completion()
            } else {
                AlertHelper(viewController: self.vc).showPromptAlertView("关闭班级失败：只有班级的创建者才可以关闭学校")
            }
            hud.hide()
            }) { (error) in
                // error
                hud.hide()
                AlertHelper(viewController: self.vc).showPromptAlertView("关闭班级失败, 请稍后重试")
        }
    }
}