//
//  SchoolModel.swift
//  homework
//
//  Created by Liu, Naitian on 7/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class SchoolModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var name: String = ""
    dynamic var address: String?
    dynamic var creator: String = ""
    dynamic var active: Bool = true
    dynamic var createdTimestamp: Int = 0
    dynamic var updatedTimestamp: Int = 0

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class SchoolModelHelper {

    init() {

    }

    func add(uuid: String, name: String, address: String?, active: Bool, timestamp: Int) {
        let school = SchoolModel()
        school.uuid = uuid
        school.name = name
        school.address = address
        school.active = true
        if let creator = UserDefaultsHelper().getUsername() {
            school.creator = creator
        }
        school.createdTimestamp = timestamp
        school.updatedTimestamp = timestamp
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(school, update: true)
            })
        } catch {
            print(error)
        }
    }

    func close(uuid: String) {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(SchoolModel.self, key: uuid) {
                try realm.write({ 
                    item.setValue(false, forKey: "active")
                })
            }
        } catch {
            print(error)
        }
    }

    func getAll() -> [[String: String?]] {
        var schools: [[String: String?]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(SchoolModel).filter("active = true") {
                let rowDict = [
                    "uuid": item.uuid,
                    "name": item.name,
                    "address": item.address,
                    "creator": item.creator
                ]
                schools.append(rowDict)
            }
        } catch {
            print(error)
        }
        return schools
    }

    func getSchoolNameByUUID(uuid: String) -> String? {
        var schoolName: String? = nil
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(SchoolModel.self, key: uuid) {
                schoolName = item.name
            }
        } catch {
            print(error)
        }
        return schoolName
    }

    func getSchoolUUIDList() -> [String] {
        var schoolUUIDList: [String] = []
        do {
            let realm = try Realm()
            for item in realm.objects(SchoolModel).filter("active = true") {
                schoolUUIDList.append(item.uuid)
            }
        } catch {
            print(error)
        }
        return schoolUUIDList
    }


}
