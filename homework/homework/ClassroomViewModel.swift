//
//  ClassroomViewModel.swift
//  homework
//
//  Created by Liu, Naitian on 8/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import SwiftyJSON

class ClassroomViewModel {

    let classroomModelHelper = ClassroomModelHelper()
    let schoolModelHelper = SchoolModelHelper()
    let memberModelHelper = MemberModelHelper()
    let profileModelHelper = ProfileModelHelper()

    let classroomKeys = GlobalKeys.ClassroomKeys.self
    let profilesKeys = GlobalKeys.ProfileKeys.self

    init() {

    }

    func getTableViewData() -> [[String: AnyObject]] {
        var data: [[String: AnyObject]] = []
        let classrooms = self.classroomModelHelper.getList(true)
        for classroom in classrooms {
            let rowDict = self.getClassroomRowDict(classroom)
            data.append(rowDict)
        }
        return data
    }

    func getClassroomDataByUUID(classroomUUID: String) -> [String: AnyObject]? {
        if let classroom = self.classroomModelHelper.getClassroomInfo(classroomUUID) {
            let rowDict = self.getClassroomRowDict(classroom)
            return rowDict
        } else {
            return nil
        }
    }

    func getClassroomDetailedInfoByUUID(classroomUUID: String) -> [String: AnyObject]? {
        // classroom info view controller
        if let classroom = self.classroomModelHelper.getClassroomInfo(classroomUUID) {
            let classroomJSON = JSON(classroom)
            let classroomName = classroomJSON[self.classroomKeys.classroomName].stringValue
            let schoolUUID: String = classroomJSON[self.classroomKeys.schoolUUID].stringValue
            let schoolName: String = self.getSchoolName(schoolUUID)
            let classroomIntroduction = classroomJSON[self.classroomKeys.introduction].stringValue
            let classroomCode = classroomJSON[self.classroomKeys.code].stringValue
            let result_tup = self.getTeachersAndStudents(classroomUUID)
            let teachers = result_tup.0
            let students = result_tup.1
            let teacherNumberString = String(teachers.count)
            let studentNumberString = String(students.count)
            let infoDict: [String: AnyObject] = [
                self.classroomKeys.classroomName: classroomName,
                self.classroomKeys.schoolName: schoolName,
                self.classroomKeys.introduction: classroomIntroduction,
                self.classroomKeys.code: classroomCode,
                self.classroomKeys.studentNumber: studentNumberString,
                self.classroomKeys.teacherNumber: teacherNumberString,
                self.classroomKeys.teachers: teachers,
                self.classroomKeys.students: students
            ]
            return infoDict
        } else {
            return nil
        }
    }

    private func getClassroomRowDict(classroom: [String: AnyObject]) -> [String: AnyObject] {
        let classroomJSON = JSON(classroom)
        let classroomUUID: String = classroomJSON[self.classroomKeys.classroomUUID].stringValue
        let creator: String = classroomJSON[self.classroomKeys.creator].stringValue
        // get school name
        let schoolUUID: String = classroomJSON[self.classroomKeys.schoolUUID].stringValue
        let schoolName: String = self.getSchoolName(schoolUUID)
        // get teacher profile image urls and student number
        let result_tup = self.getTeacherProfilesAndStudentNumber(creator, classroomUUID: classroomUUID)
        let profiles: [[String: String]] = result_tup.0
        let studentNumberString: String = String(result_tup.1)
        //
        let rowDict: [String: AnyObject] = [
            self.classroomKeys.classroomUUID: classroomUUID,
            self.classroomKeys.classroomName: classroom[self.classroomKeys.classroomName]!,
            self.classroomKeys.schoolName: schoolName,
            self.classroomKeys.creator: creator,
            self.classroomKeys.teacherProfiles: profiles,
            self.classroomKeys.studentNumber: studentNumberString
        ]
        return rowDict
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

    private func getTeacherProfilesAndStudentNumber(creator: String, classroomUUID: String) -> ([[String: String]], Int) {
        var profiles: [[String: String]] = []
        var studentNumber: Int = 0
        let members = self.memberModelHelper.getMembersByClassroom(classroomUUID)
        for memberDict in members {
            let role: String = memberDict[self.profilesKeys.role]!
            if role == "t" {
                let userId: String = memberDict[self.profilesKeys.userId]!
                if userId == creator {
                    profiles.insert(memberDict, atIndex: 0)
                } else {
                    profiles.append(memberDict)
                }
            } else if role == "s" {
                studentNumber += 1
            }
        }
        return (profiles, studentNumber)
    }

    private func getTeachersAndStudents(classroomUUID: String) -> ([String], [String]) {
        var teachers: [String] = []
        var students: [String] = []
        let members = self.memberModelHelper.getMembersByClassroom(classroomUUID)
        for memberDict in members {
            let role: String = memberDict[self.profilesKeys.role]!
            let userId: String = memberDict[self.profilesKeys.userId]!
            if role == "t" {
                teachers.append(userId)
            } else if role == "s" {
                students.append(userId)
            }
        }
        return (teachers, students)
    }

    func getTeacherAndStudentProfiles(classroomUUID: String) -> ([[String: String]], [[String: String]]) {
        let tsTup = self.getTeachersAndStudents(classroomUUID)
        var teacherProfiles: [[String: String]] = []
        var studentProfiles: [[String: String]] = []
        for teacherUserId in tsTup.0 {
            let profileDict = self.profileModelHelper.getProfileInfo(teacherUserId)!
            teacherProfiles.append(profileDict)
        }
        for studentUserId in tsTup.1 {
            let profileDict = self.profileModelHelper.getProfileInfo(studentUserId)!
            studentProfiles.append(profileDict)
        }
        return (teacherProfiles, studentProfiles)
    }

}
