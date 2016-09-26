//
//  APIQAAnswerGetList.swift
//  homework
//
//  Created by Liu, Naitian on 9/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIQAAnswerGetList {

    let url = APIURL.qaAnswerGetList

    let role = UserDefaultsHelper().getRole()!

    typealias BeginClosureType = () -> Void
    typealias CompleteClosureType = (dataArray: [[String: AnyObject]]) -> Void
    typealias ErrorClosureType = () -> Void

    let qaKeys = GlobalKeys.QAKeys.self

    init() {

    }

    func run(questionUUID: String, pageNumber: Int, beginBlock: BeginClosureType, completeBlock: CompleteClosureType, errorBlock: ErrorClosureType) {
        let data: [String: AnyObject] = [
            self.qaKeys.role: role,
            self.qaKeys.pageNumber: pageNumber,
            self.qaKeys.questionUUID: questionUUID
        ]
        beginBlock()
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                var dataArray: [[String: AnyObject]] = []
                let answers = responseData["answers"].arrayValue
                for answer in answers {
                    dataArray.append(answer.dictionaryObject!)
                }
                completeBlock(dataArray: dataArray)
            } else {
                errorBlock()
            }
            }) { (error) in
                // error
                errorBlock()
        }
    }

}