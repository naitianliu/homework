//
//  APICommentCreate.swift
//  homework
//
//  Created by Liu, Naitian on 9/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APICommentCreate {

    let url = APIURL.commentCreate

    let username: String = UserDefaultsHelper().getUsername()!
    let role: String = UserDefaultsHelper().getRole()!

    var vc: HomeworkCommentViewController!

    let commentKeys = GlobalKeys.CommentKeys.self

    let commentModelHelper = CommentModelHelper()

    init(vc: HomeworkCommentViewController) {
        self.vc = vc
    }

    func run(submissionUUID: String, info: [String: AnyObject]) {
        let data: [String: AnyObject] = [
            self.commentKeys.submissionUUID: submissionUUID,
            "role": role,
            self.commentKeys.info: info
        ]
        CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
            // success
            self.showHUD()
            let success = responseData["success"].boolValue
            if success {
                let timestamp = responseData["timestamp"].intValue
                let commentUUID = responseData[self.commentKeys.commentUUID].stringValue
                let infoData = DataTypeConversionHelper().convertDictToNSData(info)
                self.commentModelHelper.add(commentUUID, submissionUUID: submissionUUID, author: self.username, info: infoData, createdTimestamp: timestamp)
                self.vc.dismissViewControllerAnimated(true, completion: nil)
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