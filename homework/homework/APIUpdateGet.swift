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
                    let updatesDict = responseData[self.updateKeys.updates].dictionaryValue
                    let homeworks = updatesDict[self.updateKeys.homeworks]!.arrayValue
                    self.addHomeworks(homeworks)
                    let requests = updatesDict[self.updateKeys.requests]!.arrayValue
                    self.addRequests(requests)
                    let approvals = updatesDict[self.updateKeys.approvals]!.arrayValue
                    self.addApprovals(approvals)
                    let submissions = updatesDict[self.updateKeys.submissions]!.arrayValue
                    self.addSubmissions(submissions)
                    let classrooms = updatesDict[self.updateKeys.classrooms]!.arrayValue
                    self.addClassrooms(classrooms)
                    let members = updatesDict[self.updateKeys.members]!.arrayValue
                    self.addMembers(members)
                    self.vc.reloadUpdateTable()
                    // show toast
                    let updateCount: Int = homeworks.count + requests.count + submissions.count + classrooms.count + members.count
                    let toastMessage = self.getToastMessge(updateCount)
                    self.vc.showToast(toastMessage)
                }
                self.vc.updatesTableView.pullToRefreshView.stopAnimating()
            }) { (error) in
                // error
                self.vc.updatesTableView.pullToRefreshView.stopAnimating()
                
            }
        }
    }

    private func addHomeworks(homeworks: [JSON]) {

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

    private func addSubmissions(submissions: [JSON]) {

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