//
//  PerformMigrations.swift
//  homework
//
//  Created by Liu, Naitian on 7/26/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class PerformMigrations {

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    init() {
        self.setDefaultRealmForUser()
    }

    func migrate() {
        let config = Realm.Configuration(
            schemaVersion: GlobalConstants.kRealmSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                print(oldSchemaVersion)
                if (oldSchemaVersion < 1) {

                }
                if (oldSchemaVersion < 3) {
                    migration.enumerate(ClassroomModel.className(), { (oldObject, newObject) in
                        newObject!["active"] = true
                    })
                }
                if (oldSchemaVersion < 4) {
                    migration.enumerate(ClassroomModel.className(), { (oldObject, newObject) in

                    })
                }
                if (oldSchemaVersion < 5) {
                    migration.enumerate(UpdateModel.className(), { (oldObject, newObject) in
                        newObject!["uuid"] = NSUUID().UUIDString
                    })
                }
                if (oldSchemaVersion < 6) {
                    migration.enumerate(SchoolModel.className(), { (oldObject, newObject) in
                        newObject!["active"] = true
                    })
                }
                if (oldSchemaVersion < 7) {
                    migration.enumerate(HomeworkModel.className(), { (oldObject, newObject) in
                        let infoData = oldObject!["info"] as! NSData
                        let infoDict = DataTypeConversionHelper().convertNSDataToDict(infoData)
                        newObject!["dueDateTimestamp"] = infoDict[self.homeworkKeys.dueDateTimestamp] as! Int
                    })
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }

    func setDefaultRealmForUser() {
        if let username = UserDefaultsHelper().getUsername(), let role = UserDefaultsHelper().getRole() {
            var config = Realm.Configuration()
            // Use the default directory, but replace the filename with the username
            config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(username)-\(role).realm")
            // Set this as the configuration used for the default Realm
            config.schemaVersion = GlobalConstants.kRealmSchemaVersion
            Realm.Configuration.defaultConfiguration = config
        }
    }
}