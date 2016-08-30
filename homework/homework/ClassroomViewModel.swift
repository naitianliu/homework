//
//  ClassroomViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 8/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class ClassroomViewModel {

    let classroomModelHelper = ClassroomModelHelper()
    let schoolModelHelper = SchoolModelHelper()
    let memberModelHelper = MemberModelHelper()

    init() {

    }

    func getTableViewData() -> [[String: AnyObject]] {
        var data: [[String: AnyObject]] = []
        let classrooms = self.classroomModelHelper.getList(true)
        for classroom in classrooms {
            let classroomUUID: String = classroom["uuid"]!
            // get school name
            let schoolUUID: String = classroom["school_uuid"]!
            let schoolName: String = self.getSchoolName(schoolUUID)
            // get teacher profile image urls and student number
            let result_tup = self.getTeacherProfileImgURLsAndStudentNumber(classroomUUID)
            let profileImgURLs: [String] = result_tup.0
            let studentNumberString: String = String(result_tup.1)
            //
            let rowDict: [String: AnyObject] = [
                "classroomUUID": classroomUUID,
                "classroomName": classroom["name"]!,
                "schoolName": schoolName,
                "profileImgURLs": profileImgURLs,
                "studentNumber": studentNumberString
            ]
            data.append(rowDict)
        }
        return data
    }

    private func getSchoolName(schoolUUID: String) -> String {
        var schoolName: String = "未知"
        if let tempSchoolName = self.schoolModelHelper.getSchoolNameByUUID(schoolUUID) {
            schoolName = tempSchoolName
        } else {
            // refresh school list
        }
        return schoolName
    }

    private func getTeacherProfileImgURLsAndStudentNumber(classroomUUID: String) -> ([String], Int) {
        var profileImgURLs: [String] = []
        var studentNumber: Int = 0
        let members = self.memberModelHelper.getMembersByClassroom(classroomUUID)
        for memberDict in members {
            let role: String = memberDict["role"]!
            if role == "t" {
                let imgURL: String = memberDict["imgURL"]!
                profileImgURLs.append(imgURL)
            } else if role == "s" {
                studentNumber += 1
            }
        }
        return (profileImgURLs, studentNumber)
    }

}