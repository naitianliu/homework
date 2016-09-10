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

    let role: String = UserDefaultsHelper().getRole()!

    var vc: HomeworkCommentViewController!

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    init(vc: HomeworkCommentViewController) {
        self.vc = vc
    }

    func run(submissionUUID: String) {
        let data: [String: AnyObject] = [
            self.submissionKeys.submissionUUID: submissionUUID,
            "role": role
        ]
    }

}