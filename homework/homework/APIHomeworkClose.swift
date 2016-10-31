//
//  APIHomeworkClose.swift
//  homework
//
//  Created by Liu, Naitian on 9/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class APIHomeworkClose {

    let url = APIURL.homeworkClose

    let role = UserDefaultsHelper().getRole()!

    let homeworkModelHelper = HomeworkModelHelper()

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    var vc: HomeworkDetailViewController!

    init(vc: HomeworkDetailViewController) {
        self.vc = vc
    }

    func run(homeworkUUID: String) {
        let data: [String: AnyObject] = [
            self.homeworkKeys.homeworkUUID: homeworkUUID,
            "role": role
        ]
        let hudHelper = ProgressHUDHelper(view: self.vc.view)
        hudHelper.show()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            let success = responseData["success"].boolValue
            if success {
                self.homeworkModelHelper.close(homeworkUUID)
                self.vc.navigationController?.popViewControllerAnimated(true)
                if let didCloseHomework = self.vc.didCloseHomeworkBlock {
                    didCloseHomework()
                }
            }
            hudHelper.hide()
            }) { (error) in
                // error
                hudHelper.hide()
        }
    }
}