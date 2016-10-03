//
//  APIHomeworkGetSubmissionInfo.swift
//  homework
//
//  Created by Liu, Naitian on 10/2/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIHomeworkGetSubmissionInfo {

    let url = APIURL.homeworkGetSubmissionInfo

    let role: String = UserDefaultsHelper().getRole()!

    let submissionKeys = GlobalKeys.SubmissionKeys.self
    let commentKeys = GlobalKeys.CommentKeys.self

    let submissionModelHelper = SubmissionModelHelper()
    let commentModelHelper = CommentModelHelper()

    let dataConverter = DataTypeConversionHelper()

    let vc: StudentHomeworkDetailViewController!

    init(vc: StudentHomeworkDetailViewController) {
        self.vc = vc
    }

    func run(submissionUUID: String) {
        let data: [String: AnyObject] = [
            "role": self.role,
            self.submissionKeys.submissionUUID: submissionUUID
        ]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let submission = responseData["submission"]
                self.addSubmissionItem(submission)
                let comments = responseData["comments"].arrayValue
                for comment in comments {
                    self.addCommentItem(comment)
                }
                self.vc.reloadTable()
            }
            self.vc.tableView.pullToRefreshView.stopAnimating()
            }) { (error) in
                // error
                self.vc.tableView.pullToRefreshView.stopAnimating()
        }
    }

    private func addSubmissionItem(submission: JSON) {
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

    private func addCommentItem(comment: JSON) {
        let commentUUID = comment[self.commentKeys.commentUUID].stringValue
        let submissionUUID = comment[self.commentKeys.submissionUUID].stringValue
        let author = comment[self.commentKeys.author].stringValue
        let createdTimestamp = comment[self.commentKeys.createdTimestamp].intValue
        let infoDict = comment[self.commentKeys.info].dictionaryObject!
        let infoData = self.dataConverter.convertDictToNSData(infoDict)
        self.commentModelHelper.add(commentUUID, submissionUUID: submissionUUID, author: author, info: infoData, createdTimestamp: createdTimestamp)
    }

}