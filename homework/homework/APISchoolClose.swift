//
//  APISchoolClose.swift
//  homework
//
//  Created by Liu, Naitian on 10/2/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class APISchoolClose {

    let url = APIURL.schoolClose

    var vc: SelectSchoolViewController!

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let schoolModelHelper = SchoolModelHelper()

    typealias CompleteClosureType = () -> Void

    init(vc: SelectSchoolViewController) {
        self.vc = vc
    }

    func run(schoolUUID: String, completion: CompleteClosureType) {
        let data: [String: AnyObject] = [
            self.classroomKeys.schoolUUID: schoolUUID
        ]
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            let success = responseData["success"].boolValue
            if success {
                self.schoolModelHelper.close(schoolUUID)
                completion()
            } else {
                AlertHelper(viewController: self.vc).showPromptAlertView("关闭学校失败：只有学校的创建者才可以关闭学校")
            }
            }) { (error) in
                // error
                AlertHelper(viewController: self.vc).showPromptAlertView("关闭学校失败, 请稍后重试")
        }
    }
}