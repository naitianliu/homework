//
//  APIQAQuestionGetList.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIQAQuestionGetList {

    let url = APIURL.qaQestionGetList

    let role = UserDefaultsHelper().getRole()!

    var schoolUUID: String = ""

    typealias BeginClosureType = () -> Void
    typealias CompleteClosureType = (dataArray: [[String: AnyObject]]) -> Void
    typealias ErrorClosureType = () -> Void

    let qaKeys = GlobalKeys.QAKeys.self

    init() {
        let schoolUUIDList = SchoolModelHelper().getSchoolUUIDList()
        if schoolUUIDList.count > 0 {
            self.schoolUUID = schoolUUIDList[0]
        }
    }

    func run(pageNumber: Int, beginBlock: BeginClosureType, completeBlock: CompleteClosureType, errorBlock: ErrorClosureType) {
        let data: [String: AnyObject] = [
            self.qaKeys.role: role,
            self.qaKeys.pageNumber: pageNumber,
            self.qaKeys.schoolUUID: self.schoolUUID
        ]
        beginBlock()
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                var dataArray: [[String: AnyObject]] = []
                let questions = responseData["questions"].arrayValue
                for question in questions {
                    dataArray.append(question.dictionaryObject!)
                }
                completeBlock(dataArray: dataArray)
            } else {
                errorBlock()
            }
            }) { (error) in
                errorBlock()
        }
    }

}