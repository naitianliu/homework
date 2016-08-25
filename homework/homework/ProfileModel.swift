//
//  ProfileModel.swift
//  homework
//
//  Created by Liu, Naitian on 8/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class ProfileModel: Object {
    
    dynamic var userId: String = ""
    dynamic var nickname: String = ""
    dynamic var imgURL: String = ""

    override static func primaryKey() -> String {
        return "userId"
    }

}

class ProfileModelHelper {
    init() {

    }

    func add(userId: String, nickname: String, imgURL: String) {
        let profile = ProfileModel()
        profile.userId = userId
        profile.nickname = nickname
        profile.imgURL = imgURL
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(profile, update: true)
            })
        } catch {
            print(error)
        }
    }

    func getProfileInfo(userId: String) -> [String: String]? {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(ProfileModel.self, key: userId) {
                let profileInfo: [String: String] = [
                    "userId": userId,
                    "nickname": item.nickname,
                    "imgURL": item.imgURL
                ]
                return profileInfo
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    func getList() -> [[String: String]] {
        var profiles: [[String: String]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(ProfileModel.self) {
                let rowDict = [
                    "userId": item.userId,
                    "nickname": item.nickname,
                    "imgURL": item.imgURL
                ]
                profiles.append(rowDict)
            }
        } catch {
            print(error)
        }
        return profiles
    }

}


