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
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }

    func setDefaultRealmForUser() {
        if let username = UserDefaultsHelper().getUsername() {
            var config = Realm.Configuration()
            // Use the default directory, but replace the filename with the username
            config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(username).realm")
            // Set this as the configuration used for the default Realm
            config.schemaVersion = GlobalConstants.kRealmSchemaVersion
            Realm.Configuration.defaultConfiguration = config
        }
    }
}