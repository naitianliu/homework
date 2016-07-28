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
    dynamic var introduction: String = ""
    dynamic var address: String = ""
    dynamic var creator: String = ""

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class SchoolModelHelper {

    init() {

    }

    func add(uuid: String, name: String, introduction: String, address: String, creator: String) {
        let school = SchoolModel()
        school.uuid = uuid
        school.name = name
        school.introduction = introduction
        school.address = address
        school.creator = creator
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(school)
            })
        } catch {
            print(error)
        }
    }

    func getAll() -> [[String: String]] {
        var schools: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(SchoolModel) {
                let rowDict = [
                    "uuid": item.uuid,
                    "name": item.name,
                    "introduction": item.introduction,
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
