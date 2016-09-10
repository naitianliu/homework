//
//  APIHomeworkSubmit.swift
//  homework
//
//  Created by Liu, Naitian on 9/8/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIHomeworkSubmit {

    let url = APIURL.homeworkSubmit

    let role: String = UserDefaultsHelper().getRole()!

    let submitter: String = UserDefaultsHelper().getUsername()!

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    let submissionModelHelper = SubmissionModelHelper()

    var vc: StudentHomeworkDetailViewController!

    init(vc: StudentHomeworkDetailViewController!) {
        self.vc = vc
    }

    func run(homeworkUUID: String, info: [String: AnyObject]) {
        let data: [String: AnyObject] = [
            self.submissionKeys.homeworkUUID: homeworkUUID,
            "role": role,
            self.submissionKeys.info: info
        ]
        self.showHUD()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            let success = responseData["success"].boolValue
            if success {
                let timestamp = responseData[self.submissionKeys.timestamp].intValue
                let submissionUUID = responseData[self.submissionKeys.submissionUUID].stringValue
                let infoData = DataTypeConversionHelper().convertDictToNSData(info)
                self.submissionModelHelper.add(submissionUUID, homeworkUUID: homeworkUUID, submitter: self.submitter, score: nil, createdTimestamp: timestamp, updatedTimestamp: timestamp, info: infoData)
                self.vc.submissionUUID = submissionUUID
                self.vc.reloadTable()
            } else {
                // handle error
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