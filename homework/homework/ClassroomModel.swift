//
//  ClassroomModel.swift
//  homework
//
//  Created by Liu, Naitian on 7/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

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

    let Keys = GlobalKeys.ClassroomKeys.self

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

    private func getRowDictByItem(item: ClassroomModel) -> [String: AnyObject] {
        let rowDict: [String: AnyObject] = [
            self.Keys.classroomUUID: item.uuid,
            self.Keys.classroomName: item.name,
            self.Keys.introduction: item.introduction,
            self.Keys.creator: item.creator,
            self.Keys.schoolUUID: item.schoolUUID,
            self.Keys.code: item.code,
            self.Keys.active: item.active
        ]
        return rowDict
    }
}

