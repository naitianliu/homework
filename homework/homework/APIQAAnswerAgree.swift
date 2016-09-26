//
//  APIQAAnswerAgree.swift
//  homework
//
//  Created by Liu, Naitian on 9/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class APIQAAnswerAgree {

    let url = APIURL.qaAnswerAgree

    let role = UserDefaultsHelper().getRole()!

    let qaKeys = GlobalKeys.QAKeys.self

    init() {

    }

    func run(answerUUID: String, agree: Bool) {
        let data: [String: AnyObject] = [
            "role": role,
            self.qaKeys.answerUUID: answerUUID,
            self.qaKeys.agree: agree
        ]
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            }) { (error) in
                // false
        }
    }
}