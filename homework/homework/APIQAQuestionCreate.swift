//
//  APIQAQuestionCreate.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIQAQuestionCreate {

    let url = APIURL.qaQestionCreate

    let role = UserDefaultsHelper().getRole()!

    var vc: QAQuestionCreateViewController!

    let qaKeys = GlobalKeys.QAKeys.self

    init(vc: QAQuestionCreateViewController) {
        self.vc = vc
    }

    func run(classroomUUID: String, anonymous: Bool, content: String) {
        let data: [String: AnyObject] = [
            self.qaKeys.role: role,
            self.qaKeys.classroomUUID: classroomUUID,
            self.qaKeys.anonymous: anonymous,
            self.qaKeys.content: content
        ]
        let hudHelper = ProgressHUDHelper(view: self.vc.view)
        hudHelper.show()
        CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
            // success
            hudHelper.hide()
            self.vc.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                // error
                hudHelper.hide()
                AlertHelper(viewController: self.vc).showPromptAlertView("发布问题失败，请稍后重试")
        }
    }

}