//
//  APICommentGetList.swift
//  homework
//
//  Created by Liu, Naitian on 10/2/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APICommentGetList {

    let url = APIURL.commentGetList

    let role: String = UserDefaultsHelper().getRole()!

    let commentKeys = GlobalKeys.CommentKeys.self

    let commentModelHelper = CommentModelHelper()

    let dataConverter = DataTypeConversionHelper()

    var vc: HomeworkGradeViewController!

    init(vc: HomeworkGradeViewController) {
        self.vc = vc
    }

    func run(submissionUUID: String) {
        let data: [String: AnyObject] = [
            "role": self.role,
            self.commentKeys.submissionUUID: submissionUUID
        ]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let comments = responseData["comments"].arrayValue
                for comment in comments {
                    self.addItem(comment)
                }
                self.vc.reloadTable()
            }
            self.vc.tableView.pullToRefreshView.stopAnimating()
            }) { (error) in
                // error
                self.vc.tableView.pullToRefreshView.stopAnimating()
        }
    }

    private func addItem(comment: JSON) {
        let commentUUID = comment[self.commentKeys.commentUUID].stringValue
        let submissionUUID = comment[self.commentKeys.submissionUUID].stringValue
        let author = comment[self.commentKeys.author].stringValue
        let createdTimestamp = comment[self.commentKeys.createdTimestamp].intValue
        let infoDict = comment[self.commentKeys.info].dictionaryObject!
        let infoData = self.dataConverter.convertDictToNSData(infoDict)
        self.commentModelHelper.add(commentUUID, submissionUUID: submissionUUID, author: author, info: infoData, createdTimestamp: createdTimestamp)
    }

}