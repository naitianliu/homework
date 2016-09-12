//
//  CommentViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/10/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentViewModel {

    let commentModelHelper = CommentModelHelper()
    let profileModelHelper = ProfileModelHelper()

    let commentKeys = GlobalKeys.CommentKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self

    let dateUtility = DateUtility()
    let dataConverter = DataTypeConversionHelper()

    init() {

    }

    func getCommentsList(submissionUUID: String) -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        let comments = self.commentModelHelper.getList(submissionUUID)
        for comment in comments {
            let rowDict = self.getRowDictBySubmission(comment)
            dataArray.insert(rowDict, atIndex: 0)
        }
        return dataArray
    }

    private func getRowDictBySubmission(comment: [String: AnyObject]) -> [String: AnyObject] {
        let commentUUID = comment[self.commentKeys.commentUUID] as! String
        let submissionUUID = comment[self.commentKeys.submissionUUID] as! String
        // author profile info
        let author = comment[self.commentKeys.author] as! String
        var authorName: String = ""
        var authorImgURL: String = ""
        if let profileInfo = self.profileModelHelper.getProfileInfo(author) {
            authorName = profileInfo[self.profileKeys.nickname]!
            authorImgURL = profileInfo[self.profileKeys.imgURL]!
        }
        // date time
        let createdTimestamp = comment[self.commentKeys.createdTimestamp] as! Int
        let timeString = self.dateUtility.convertEpochToHumanFriendlyString(createdTimestamp)
        //
        let infoData = comment[self.commentKeys.info] as! NSData
        let infoDict = self.dataConverter.convertNSDataToDict(infoData)
        let infoJSON = JSON(infoDict)
        let text = infoJSON[self.commentKeys.text].stringValue
        var rowDict: [String: AnyObject] = [
            self.commentKeys.commentUUID: commentUUID,
            self.commentKeys.submissionUUID: submissionUUID,
            self.commentKeys.author: author,
            self.commentKeys.authorName: authorName,
            self.commentKeys.authorImgURL: authorImgURL,
            self.commentKeys.time: timeString,
            self.commentKeys.text: text
        ]
        if let audioInfo = infoJSON[self.commentKeys.audioInfo].dictionaryObject {
            rowDict[self.commentKeys.hasAudio] = true
            rowDict[self.commentKeys.audioInfo] = audioInfo
        } else {
            rowDict[self.commentKeys.hasAudio] = false
        }
        return rowDict
    }
}