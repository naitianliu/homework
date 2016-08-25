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
    dynamic var createdTimestamp: Int = 0
    dynamic var updatedTimestamp: Int = 0

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class SchoolModelHelper {

    init() {

    }

    func add(uuid: String, name: String, address: String?, timestamp: Int) {
        let school = SchoolModel()
        school.uuid = uuid
        school.name = name
        school.address = address
        if let creator = UserDefaultsHelper().getUsername() {
            school.creator = creator
        }
        school.createdTimestamp = timestamp
        school.updatedTimestamp = timestamp
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(school)
            })
        } catch {
            print(error)
        }
    }

    func getAll() -> [[String: String?]] {
        var schools: [[String: String?]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(SchoolModel) {
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


}
