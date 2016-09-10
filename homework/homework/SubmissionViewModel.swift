//
//  SubmissionViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/8/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubmissionViewModel {

    let submissionModelHelper = SubmissionModelHelper()
    let profileModelHelper = ProfileModelHelper()

    let submissionKeys = GlobalKeys.SubmissionKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self

    let dateUtility = DateUtility()

    init() {

    }

    func getSubmissionList(homeworkUUID: String) -> ([[String: AnyObject?]], [[String: AnyObject?]]) {
        // Teacher Only
        var ungradedArray: [[String: AnyObject?]] = []
        var gradedArray: [[String: AnyObject?]] = []
        let submissions = self.submissionModelHelper.getListByHomework(homeworkUUID)
        for submission in submissions {
            let score = submission[self.submissionKeys.score] as? String
            let rowDict = self.getRowDictBySubmission(submission).0
            if score == nil {
                ungradedArray.append(rowDict)
            } else {
                gradedArray.append(rowDict)
            }
        }
        return (ungradedArray, gradedArray)
    }

    func getSubmissionData(submissionUUID: String) -> ([String: AnyObject?], [[String: AnyObject]])? {
        // Student only
        if let submissionInfo = self.submissionModelHelper.getSubmissionInfoByUUID(submissionUUID) {
            let rowTup = self.getRowDictBySubmission(submissionInfo)
            let rowDict = rowTup.0
            let info = rowTup.1
            let submissionArray = self.getSubmissionArrayByInfo(info)
            return (rowDict, submissionArray)
        } else {
            return nil
        }
    }

    func getSubmissionUUIDByHomeworkUUID(homeworkUUID: String) -> String? {
        let submissions = self.submissionModelHelper.getListByHomework(homeworkUUID)
        if submissions.count == 0 {
            return nil
        } else {
            let rowDict = submissions[0]
            let submissionUUID = rowDict[self.submissionKeys.submissionUUID]! as! String
            return submissionUUID
        }
    }

    private func getRowDictBySubmission(submission: [String: AnyObject?]) -> ([String: AnyObject?], NSData) {
        let submissionUUID: String = submission[self.submissionKeys.submissionUUID] as! String
        let homeworkUUID: String = submission[self.submissionKeys.homeworkUUID] as! String
        let submitter: String = submission[self.submissionKeys.submitter] as! String
        let score: String? = submission[self.submissionKeys.score] as? String
        let createdTimestamp: Int = submission[self.submissionKeys.createdTimestamp] as! Int
        let info: NSData = submission[self.submissionKeys.info] as! NSData
        let profileInfo: [String: String] = self.profileModelHelper.getProfileInfo(submitter)!
        let rowDict: [String: AnyObject?] = [
            self.submissionKeys.submitterName: profileInfo[self.profileKeys.nickname],
            self.submissionKeys.submitterImgURL: profileInfo[self.profileKeys.imgURL],
            self.submissionKeys.time: self.dateUtility.convertEpochToHumanFriendlyString(createdTimestamp),
            self.submissionKeys.score: score,
            self.submissionKeys.submissionUUID: submissionUUID,
            self.submissionKeys.homeworkUUID: homeworkUUID
        ]
        return (rowDict, info)
    }

    private func getSubmissionArrayByInfo(info: NSData) -> [[String: AnyObject]] {
        var submissionArray: [[String: AnyObject]] = []
        let infoDict = DataTypeConversionHelper().convertNSDataToDict(info)
        let infoJSON = JSON(infoDict)
        let audioList = infoJSON[self.submissionKeys.audioList].arrayValue
        for audio in audioList {
            let rowDict: [String: AnyObject] = [
                self.submissionKeys.submissionType: "audio",
                self.submissionKeys.duration: audio[self.submissionKeys.duration].intValue,
                self.submissionKeys.audioURL: audio[self.submissionKeys.audioURL].stringValue
            ]
            submissionArray.append(rowDict)
        }
        return submissionArray
    }
}