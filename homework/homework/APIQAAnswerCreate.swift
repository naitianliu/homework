//
//  APIQAAnswerCreate.swift
//  homework
//
//  Created by Liu, Naitian on 9/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIQAAnswerCreate {

    let url = APIURL.qaAnswerCreate

    let role = UserDefaultsHelper().getRole()!

    var vc: QAAnswerCreateViewController!

    let qaKeys = GlobalKeys.QAKeys.self

    init(vc: QAAnswerCreateViewController) {
        self.vc = vc
    }

    func run(questionUUID: String, classroomUUID: String, anonymous: Bool, content: String) {
        let data: [String: AnyObject] = [
            self.qaKeys.role: role,
            self.qaKeys.questionUUID: questionUUID,
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
            AlertHelper(viewController: self.vc).showPromptAlertView("发布失败，请稍后重试")
        }
    }
}