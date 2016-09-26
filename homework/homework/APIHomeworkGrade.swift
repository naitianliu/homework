//
//  APIHomeworkGrade.swift
//  homework
//
//  Created by Liu, Naitian on 9/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import MBProgressHUD

class APIHomeworkGrade {

    let url = APIURL.homeworkGrade

    let role: String = UserDefaultsHelper().getRole()!

    var vc: HomeworkGradeViewController!

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    let submissionModelHelper = SubmissionModelHelper()

    init(vc: HomeworkGradeViewController) {
        self.vc = vc
    }

    func run(submissionUUID: String, score: String) {
        let data: [String: AnyObject] = [
            "role": role,
            self.submissionKeys.score: score,
            self.submissionKeys.submissionUUID: submissionUUID
        ]
        self.showHUD()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            let success = responseData["success"].boolValue
            print(success)
            if success {
                self.submissionModelHelper.updateScore(submissionUUID, score: score)
                self.vc.reloadTable()
            }
            self.hideHUD()
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