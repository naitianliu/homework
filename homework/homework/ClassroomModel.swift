//
//  ClassroomModel.swift
//  homework
//
//  Created by Liu, Naitian on 7/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ClassroomModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var name: String = ""
    dynamic var introduction: String = ""
    dynamic var creator: String = ""
    dynamic var schoolUUID: String = ""
    dynamic var code: String = ""
    dynamic var active: Bool = true
    dynamic var createdTimestamp: Int = 0
    dynamic var updatedTimestamp: Int = 0

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class ClassroomModelHelper {

    let memberModelHelper = MemberModelHelper()

    let classroomKeys = GlobalKeys.ClassroomKeys.self

    let profileModelHelper = ProfileModelHelper()

    let profileKeys = GlobalKeys.ProfileKeys.self

    let schoolModelHelper = SchoolModelHelper()

    init() {

    }

    func add(uuid: String, name: String, introduction: String, creator: String?, schoolUUID: String, code: String, active: Bool, createdTimestamp: Int, updatedTimestamp: Int, members: [[String: String]]?) {
        let classroom = ClassroomModel()
        classroom.uuid = uuid
        classroom.name = name
        classroom.introduction = introduction
        classroom.schoolUUID = schoolUUID
        classroom.code = code
        classroom.active = active
        classroom.createdTimestamp = createdTimestamp
        classroom.updatedTimestamp = updatedTimestamp
        if let creator = creator {
            classroom.creator = creator
        } else {
            classroom.creator = UserDefaultsHelper().getUsername()!
        }
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(classroom, update: true)
            })
        } catch {
            print(error)
        }
        if let members = members {
            self.memberModelHelper.deleteMembers(uuid)
            self.memberModelHelper.addMembers(uuid, members: members)
        }
    }

    func close(uuid: String) {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(ClassroomModel.self, key: uuid) {
                try realm.write({ 
                    item.setValue(false, forKey: "active")
                })
            }
        } catch {
            print(error)
        }
    }

    func getList(active: Bool) -> [[String: AnyObject]] {
        var classrooms: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(ClassroomModel).filter("active = \(active)") {
                let rowDict = self.getRowDictByItem(item)
                classrooms.append(rowDict)
            }
        } catch {
            print(error)
        }
        return classrooms
    }

    func getUUIDList(active: Bool) -> [String] {
        var uuidList: [String] = []
        do {
            let realm = try Realm()
            for item in realm.objects(ClassroomModel).filter("active = \(active)") {
                uuidList.append(item.uuid)
            }
        } catch {
            print(error)
        }
        return uuidList
    }

    func getClassroomInfo(uuid: String) -> [String: AnyObject]? {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(ClassroomModel.self, key: uuid) {
                let classroomInfo: [String: AnyObject] = self.getRowDictByItem(item)
                return classroomInfo
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    func getClassroomNameByUUID(uuid: String) -> String? {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(ClassroomModel.self, key: uuid) {
                let name = item.name
                return name
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    private func getRowDictByItem(item: ClassroomModel) -> [String: AnyObject] {
        let rowDict: [String: AnyObject] = [
            self.classroomKeys.classroomUUID: item.uuid,
            self.classroomKeys.classroomName: item.name,
            self.classroomKeys.introduction: item.introduction,
            self.classroomKeys.creator: item.creator,
            self.classroomKeys.schoolUUID: item.schoolUUID,
            self.classroomKeys.code: item.code,
            self.classroomKeys.active: item.active
        ]
        return rowDict
    }

    func addUpdateClassroom(classroomData: JSON) {
        let name = classroomData[self.classroomKeys.classroomName].stringValue
        let code = classroomData[self.classroomKeys.code].stringValue
        let creator = classroomData[self.classroomKeys.creator].stringValue
        let introduction = classroomData[self.classroomKeys.introduction].stringValue
        let schoolUUID = classroomData[self.classroomKeys.schoolUUID].stringValue
        let schoolInfo = classroomData[self.classroomKeys.schoolInfo]
        let classroomUUID = classroomData[self.classroomKeys.classroomUUID].stringValue
        let active = classroomData[self.classroomKeys.active].boolValue
        let createdTimestamp = classroomData[self.classroomKeys.createdTimestamp].intValue
        let updatedTimestamp = classroomData[self.classroomKeys.updatedTimestamp].intValue
        var members: [[String: String]] = []
        for item in classroomData["members"].arrayValue {
            let memberJSON = item.dictionaryValue
            let memberDict: [String: String] = [
                "user_id": memberJSON["user_id"]!.stringValue,
                "role": memberJSON["role"]!.stringValue
            ]
            members.append(memberDict)
            // add or update profile
            let profile = memberJSON["profile"]!
            let userId = profile[self.profileKeys.userId].stringValue
            let imgURL = profile[self.profileKeys.imgURL].stringValue
            let nickname = profile[self.profileKeys.nickname].stringValue
            self.profileModelHelper.add(userId, nickname: nickname, imgURL: imgURL)

        }
        self.add(classroomUUID, name:name, introduction: introduction, creator: creator,
                                      schoolUUID: schoolUUID, code: code, active: active, createdTimestamp: createdTimestamp, updatedTimestamp: updatedTimestamp,
                                      members: members)
        // add school
        let schoolName = schoolInfo[self.classroomKeys.schoolName].stringValue
        let schoolAddress = schoolInfo[self.classroomKeys.schoolAddress].string
        let schoolTimestamp = schoolInfo[self.classroomKeys.createdTimestamp].intValue
        let schoolActive = schoolInfo[self.classroomKeys.active].boolValue
        self.schoolModelHelper.add(schoolUUID, name: schoolName, address: schoolAddress, active: schoolActive, timestamp: schoolTimestamp)

    }
}

