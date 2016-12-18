//
//  APIUpdateGet.swift
//  homework
//
//  Created by Liu, Naitian on 9/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIUpdateGet {

    let url = APIURL.updateGet

    let role = UserDefaultsHelper().getRole()

    let updateModelHelper = UpdateModelHelper()
    let classroomModelHelper = ClassroomModelHelper()

    let vc: HomeViewController!

    let updateKeys = GlobalKeys.UpdateKeys.self
    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let homeworkKeys = GlobalKeys.HomeworkKeys.self
    let submissionKeys = GlobalKeys.SubmissionKeys.self
    let profileKeys = GlobalKeys.ProfileKeys.self

    init(vc: HomeViewController) {
        self.vc = vc
    }

    func run() {
        if let role = role {
            let data = ["role": role]
            CallAPIHelper(url: url, data: data).GET({ (responseData) in
                // success
                let errorCode = responseData["error"].intValue
                if errorCode == 0 {
                    var updateCount: Int = 0
                    let updatesDict = responseData[self.updateKeys.updates].dictionaryValue
                    if let homeworks = updatesDict[self.updateKeys.homeworks] {
                        self.addHomeworks(homeworks.arrayValue)
                        updateCount += homeworks.count
                    }
                    if let requests = updatesDict[self.updateKeys.requests] {
                        self.addRequests(requests.arrayValue)
                        updateCount += requests.count
                    }
                    if let approvals = updatesDict[self.updateKeys.approvals] {
                        self.addApprovals(approvals.arrayValue)
                        updateCount += approvals.count
                    }
                    if let submissions = updatesDict[self.updateKeys.submissions] {
                        self.addSubmissions(submissions.arrayValue)
                        updateCount += submissions.count
                    }
                    if let classrooms = updatesDict[self.updateKeys.classrooms] {
                        self.addClassrooms(classrooms.arrayValue)
                        updateCount += classrooms.count
                    }
                    if let members = updatesDict[self.updateKeys.members] {
                        self.addMembers(members.arrayValue)
                        updateCount += members.count
                    }
                    if let grades = updatesDict[self.updateKeys.grades] {
                        self.addGrades(grades.arrayValue)
                        updateCount += grades.count
                    }
                    if let comments = updatesDict[self.updateKeys.comments] {
                        self.addComments(comments.arrayValue)
                        updateCount += comments.count
                    }
                    self.vc.reloadUpdateTable()
                    // show toast
                    let toastMessage = self.getToastMessge(updateCount)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.vc.showToast(toastMessage)
                    }
                }
                self.vc.updatesTableView.pullToRefreshView.stopAnimating()
            }) { (error) in
                // error
                self.vc.updatesTableView.pullToRefreshView.stopAnimating()
            }
        }
    }

    private func addComments(comments: [JSON]) {
        let type = self.updateKeys.comments
        for item in comments {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let submissionUUID = item[self.submissionKeys.submissionUUID].stringValue
            let homeworkUUID = item[self.submissionKeys.homeworkUUID].stringValue
            let authorProfileInfo = item[self.updateKeys.authorProfileInfo].dictionaryObject!
            let info = item[self.updateKeys.info].dictionaryObject!
            let infoDict: [String: AnyObject] = [
                self.submissionKeys.submissionUUID: submissionUUID,
                self.submissionKeys.homeworkUUID: homeworkUUID,
                self.updateKeys.authorProfileInfo: authorProfileInfo,
                self.updateKeys.info: info
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
        }
    }

    private func addGrades(grades: [JSON]) {
        let type = self.updateKeys.grades
        for item in grades {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let submissionUUID = item[self.submissionKeys.submissionUUID].stringValue
            let score = item[self.submissionKeys.score].stringValue
            let infoDict: [String: AnyObject] = [
                self.submissionKeys.submissionUUID: submissionUUID,
                self.submissionKeys.score: score
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
        }
    }

    private func addSubmissions(submissions: [JSON]) {
        let type = self.updateKeys.submissions
        for item in submissions {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let studentUserId = item[self.updateKeys.studentUserId].stringValue
            let studentNickname = item[self.updateKeys.studentNickname].stringValue
            let homeworkUUID = item[self.homeworkKeys.homeworkUUID].stringValue
            let infoDict: [String: AnyObject] = [
                self.homeworkKeys.homeworkUUID: homeworkUUID,
                self.updateKeys.studentUserId: studentUserId,
                self.updateKeys.studentNickname: studentNickname
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
        }
    }

    private func addHomeworks(homeworks: [JSON]) {
        let type = self.updateKeys.homeworks
        for item in homeworks {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let classroomUUID = item[self.homeworkKeys.classroomUUID].stringValue
            let classroomName = item[self.classroomKeys.classroomName].stringValue
            let infoDict: [String: AnyObject] = [
                self.homeworkKeys.classroomUUID: classroomUUID,
                self.classroomKeys.classroomName: classroomName
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
        }
    }

    private func addRequests(requests: [JSON]) {
        let type = self.updateKeys.requests
        for item in requests {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let classroomUUID = item[self.homeworkKeys.classroomUUID].stringValue
            let requestUUID = item[self.updateKeys.requestUUID].stringValue
            let requesterProfile = item[self.updateKeys.requesterProfile].dictionaryObject!
            let infoDict: [String: AnyObject] = [
                self.homeworkKeys.classroomUUID: classroomUUID,
                self.updateKeys.requestUUID: requestUUID,
                self.updateKeys.requesterProfile: requesterProfile
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
        }
    }

    private func addApprovals(approvals: [JSON]) {
        let type = self.updateKeys.approvals
        for item in approvals {
            let timestamp = item[self.updateKeys.timestamp].intValue
            let classroomInfo = item[self.updateKeys.classroomInfo]
            let classroomUUID = item[self.classroomKeys.classroomUUID].stringValue
            let classroomName = item[self.classroomKeys.classroomName].stringValue
            let approverProfileInfo = item[self.updateKeys.approverProfileInfo]
            let infoDict: [String: AnyObject] = [
                self.classroomKeys.classroomUUID: classroomUUID,
                self.classroomKeys.classroomName: classroomName,
                self.updateKeys.approverProfileInfo: approverProfileInfo.dictionaryObject!
            ]
            let infoData = DataTypeConversionHelper().convertDictToNSData(infoDict)
            self.updateModelHelper.add(timestamp, type: type, info: infoData)
            self.classroomModelHelper.addUpdateClassroom(classroomInfo)

        }
    }

    private func addClassrooms(classrooms: [JSON]) {

    }

    private func addMembers(members: [JSON]) {

    }

    private func getToastMessge(updateCount: Int) -> String {
        if updateCount == 0 {
            let message = "暂时没有任何更新"
            return message
        } else {
            let message = "\(updateCount) 条更新"
            return message
        }
    }

}