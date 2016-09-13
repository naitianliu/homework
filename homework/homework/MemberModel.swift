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
                let userId: String = memberDict[self.profileKeys.userId]!
                let role: String = memberDict[self.profileKeys.role]!
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

    func deleteMembers(classroomUUID: String) {
        do {
            let realm = try Realm()
            for item in realm.objects(MemberModel).filter("classroomUUID = '\(classroomUUID)'") {
                try realm.write({
                    realm.delete(item)
                })
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
                    self.profileKeys.classroomUUID: classroomUUID,
                    self.profileKeys.userId: userId,
                    self.profileKeys.role: role
                ]
                if let profileDict = self.profileModelHelper.getProfileInfo(userId) {
                    rowDict[self.profileKeys.nickname] = profileDict[self.profileKeys.nickname]
                    rowDict[self.profileKeys.imgURL] = profileDict[self.profileKeys.imgURL]
                } else {
                    rowDict[self.profileKeys.nickname] = "未知"
                    rowDict[self.profileKeys.imgURL] = ""
                }
                members.append(rowDict)
            }
        } catch {
            print(error)
        }
        return members
    }

}

