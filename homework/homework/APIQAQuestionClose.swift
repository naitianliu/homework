//
//  APIQAQuestionClose.swift
//  homework
//
//  Created by Liu, Naitian on 10/12/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIQAQuestionClose {

    let url = APIURL.qaQestionClose

    let role = UserDefaultsHelper().getRole()!

    let qaKeys = GlobalKeys.QAKeys.self

    var vc: QAAnswerViewController!

    init(vc: QAAnswerViewController) {
        self.vc = vc
    }

    func run(questionUUID: String) {
        let data: [String: AnyObject] = [
            self.qaKeys.role: role,
            self.qaKeys.questionUUID: questionUUID
        ]
        let hud = ProgressHUDHelper(view: self.vc.view)
        hud.show()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            hud.hide()
            let success = responseData["success"].boolValue
            if success {
                AlertHelper(viewController: self.vc).showPromptAlertView("此问题已关闭，返回刷新后将不再可见。")
            } else {
                AlertHelper(viewController: self.vc).showPromptAlertView("只有此问题的创建者才能关闭此问题")
            }
            }) { (error) in
                // error
                hud.hide()
                AlertHelper(viewController: self.vc).showPromptAlertView("关闭问题失败，请稍候重试")
        }
    }

}