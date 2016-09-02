//
//  HomeworkModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class HomeworkModel: Object {

    dynamic var uuid: String = ""
    dynamic var classroomUUID: String = ""
    dynamic var creator: String = ""
    dynamic var active: Bool = true
    dynamic var createdTimestamp: Int = 0
    dynamic var updatedTimestamp: Int = 0

    dynamic var type: String = ""
    dynamic var content: String = ""
    dynamic var dueDateTimestamp: Int = 0

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class HomeworkModelHelper {

    let Keys = GlobalKeys.HomeworkKeys.self

    init() {

    }

    func add(homeworkUUID: String, classroomUUID: String, creator: String?, active: Bool, createdTimestamp: Int?, updatedTimestamp: Int, type: String, content: String, dueDateTimestamp: Int) {
        let homework = HomeworkModel()
        homework.uuid = homeworkUUID
        homework.classroomUUID = classroomUUID
        if let creator = creator {
            homework.creator = creator
        } else {
            homework.creator = UserDefaultsHelper().getUsername()!
        }
        homework.active = active
        if let createdTimestamp = createdTimestamp {
            homework.createdTimestamp = createdTimestamp
        }
        homework.updatedTimestamp = updatedTimestamp
        homework.type = type
        homework.content = content
        homework.dueDateTimestamp = dueDateTimestamp
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(homework, update: true)
            })
        } catch {
            print(error)
        }
    }

    func getListByClassroom(classroomUUID: String, active: Bool) -> [[String: AnyObject]] {
        var homeworkArray: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(HomeworkModel).filter("classroomUUID = '\(classroomUUID)' AND active = \(active)") {
                let rowDict: [String: AnyObject] = [
                    Keys.homeworkUUID: item.uuid,
                    Keys.classroomUUID: item.classroomUUID,
                    Keys.creator: item.creator,
                    Keys.active: item.active,
                    Keys.createdTimestamp: item.createdTimestamp,
                    Keys.updatedTimestamp: item.updatedTimestamp,
                    Keys.type: item.type,
                    Keys.content: item.content,
                    Keys.dueDateTimestamp: item.dueDateTimestamp
                ]
                homeworkArray.append(rowDict)
            }
        } catch {
            print(error)
        }

        return homeworkArray
    }
}