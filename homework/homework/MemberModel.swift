//
//  MemberModel.swift
//  homework
//
//  Created by Liu, Naitian on 8/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class MemberModel: Object {
    
    dynamic var classroomUUID: String = ""
    dynamic var userId: String = ""
    dynamic var role: String = ""

}

class MemberModelHelper {

    let profileModelHelper = ProfileModelHelper()

    let profileKeys = GlobalKeys.ProfileKeys.self

    init() {

    }

    func addMembers(classroomUUID: String, members: [[String: String]]) {
        do {
            let realm = try Realm()
            for memberDict in members {
                let userId: String = memberDict["user_id"]!
                let role: String = memberDict["role"]!
                if realm.objects(MemberModel).filter("classroomUUID = '\(classroomUUID)' AND userId = '\(userId)' AND role = '\(role)'").count == 0 {
                    let member = MemberModel()
                    member.classroomUUID = classroomUUID
                    member.userId = userId
                    member.role = role
                    try realm.write({ 
                        realm.add(member)
                    })
                }
            }
        } catch {
            print(error)
        }
    }

    func getMembersByClassroom(classroomUUID: String) -> [[String: String]] {
        var members: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(MemberModel).filter("classroomUUID = '\(classroomUUID)'") {
                let userId = item.userId
                let role = item.role
                var rowDict = [
                    "classroomUUID": classroomUUID,
                    "userId": userId,
                    "role": role
                ]
                if let profileDict = self.profileModelHelper.getProfileInfo(userId) {
                    rowDict["nickname"] = profileDict[self.profileKeys.nickname]
                    rowDict["imgURL"] = profileDict[self.profileKeys.imgURL]
                } else {
                    rowDict["nickname"] = "未知"
                    rowDict["imgURL"] = ""
                }
                members.append(rowDict)
            }
        } catch {
            print(error)
        }
        return members
    }

}

