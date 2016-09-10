//
//  APIHomeworkGetSubmissionList.swift
//  homework
//
//  Created by Liu, Naitian on 9/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIHomeworkGetSubmissionList {

    let url = APIURL.homeworkGetSubmissionList

    let role: String = UserDefaultsHelper().getRole()!

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    let submissionModelHelper = SubmissionModelHelper()

    var vc: HomeworkDetailViewController!

    init(vc: HomeworkDetailViewController) {
        self.vc = vc
    }

    func run(homeworkUUID: String) {
        self.showHUD()
        let data: [String: AnyObject] = [
            "role": self.role,
            self.submissionKeys.homeworkUUID: homeworkUUID
        ]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let submissions = responseData["submissions"].arrayValue
                for submission in submissions {
                    self.addItem(submission)
                }
                self.vc.reloadTable()
            }
            }) { (error) in
                // error
                self.hideHUD()
        }
    }

    private func addItem(submission: JSON) {
        let homeworkUUID = submission[self.submissionKeys.homeworkUUID].stringValue
        let submissionUUID = submission[self.submissionKeys.submissionUUID].stringValue
        let score = submission[self.submissionKeys.score].string
        let submitter = submission[self.submissionKeys.submitter].stringValue
        let createdTimestamp = submission[self.submissionKeys.createdTimestamp].intValue
        let updateTimestamp = submission[self.submissionKeys.updatedTimestamp].intValue
        let infoDict = submission[self.submissionKeys.info].dictionaryObject!
        let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
        self.submissionModelHelper.add(submissionUUID, homeworkUUID: homeworkUUID, submitter: submitter, score: score, createdTimestamp: createdTimestamp, updatedTimestamp: updateTimestamp, info: infoData)
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