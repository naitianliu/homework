//
//  UpdateModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class UpdateModel: Object {

    dynamic var uuid: String = ""
    dynamic var timestamp: Int = 0
    dynamic var type: String = ""
    dynamic var info: NSData = NSData()
    dynamic var read: Bool = false

    override static func primaryKey() -> String? {
        return "uuid"
    }
}

class UpdateModelHelper {

    let Keys = GlobalKeys.UpdateKeys.self

    init() {

    }

    func add(timestamp: Int, type: String, info: NSData) {
        let update = UpdateModel()
        update.uuid = NSUUID().UUIDString
        update.timestamp = timestamp
        update.type = type
        update.info = info
        update.read = false
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(update)
            })
        } catch {
            print(error)
        }
    }

    func getList() -> [[String: AnyObject]] {
        var dataArray: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(UpdateModel) {
                let rowDict = self.getUpdateRowDict(item)
                dataArray.append(rowDict)
            }
        } catch {
            print(error)
        }
        return dataArray
    }

    func getUpdateRowDict(item: UpdateModel) -> [String: AnyObject] {
        let rowDict: [String: AnyObject] = [
            self.Keys.uuid: item.uuid,
            self.Keys.timestamp: item.timestamp,
            self.Keys.type: item.type,
            self.Keys.info: item.info,
            self.Keys.read: item.read
        ]
        return rowDict
    }

    func delete(uuid: String) {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(UpdateModel.self, key: uuid) {
                try realm.write({ 
                    realm.delete(item)
                })
            }
        } catch {
            print(error)
        }
    }

    func markAsRead(uuid: String) {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(UpdateModel.self, key: uuid) {
                try realm.write({
                    item.setValue(true, forKey: "read")
                })
            }
        } catch {
            print(error)
        }
    }
}
