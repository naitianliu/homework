//
//  UserDefaultsHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/15/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

import SwiftyUserDefaults

extension DefaultsKeys {
    static let username = DefaultsKey<String?>("username")
    static let profileImageURL = DefaultsKey<String?>("profileImageURL")
    static let nickname = DefaultsKey<String?>("nickname")
    static let token = DefaultsKey<String?>("token")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let timestamp = DefaultsKey<String?>("timestamp")
    static let role = DefaultsKey<String?>("role")
    
    static let stsAccessKeySecret = DefaultsKey<String>("stsAccessKeySecret")
    static let stsSecurityToken = DefaultsKey<String>("stsSecurityToken")
    static let stsExpiration = DefaultsKey<String?>("stsExpiration")
    static let stsAccessKeyId = DefaultsKey<String>("stsAccessKeyId")
    
}

class UserDefaultsHelper {
    init() {
        
    }
    
    func getSTSCredentials() -> [String: String]? {
        let dateUtility = DateUtility()
        if let stsExpiration = Defaults[.stsExpiration] {
            let expirationEpoch = dateUtility.convertTZToEpoch(stsExpiration)
            let currentEpoch = dateUtility.getCurrentEpochTime()
            if currentEpoch < expirationEpoch - 120 {
                let credentials = [
                    "accessKeyId": Defaults[.stsAccessKeyId],
                    "accessKeySecret": Defaults[.stsAccessKeySecret],
                    "securityToken": Defaults[.stsSecurityToken],
                    "expiration": stsExpiration
                ]
                return credentials
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setSTSCredentials(stsAccessKeyId: String, stsAccessKeySecret: String, stsSecurityToken: String, stsExpiration: String) {
        Defaults[.stsAccessKeyId] = stsAccessKeyId
        Defaults[.stsAccessKeySecret] = stsAccessKeySecret
        Defaults[.stsSecurityToken] = stsSecurityToken
        Defaults[.stsExpiration] = stsExpiration
    }
    
    func getLastUpdatedTimestamp() -> String {
        if let timestamp = Defaults[.timestamp] {
            return timestamp
        } else {
            return "0"
        }
    }
    
    func updateLastUpdatedTimestamp(timestamp: String) {
        Defaults[.timestamp] = timestamp
    }
    
    func createOrUpdateUserInfo(username:String?, profileImageURL:String?, nickname:String?, token:String?) {
        if let username = username {
            Defaults[.username] = username
        }
        if let profileImageURL = profileImageURL {
            Defaults[.profileImageURL] = profileImageURL
        }
        if let nickname = nickname {
            Defaults[.nickname] = nickname
        }
        if let token = token {
            Defaults[.token] = token
        }
    }
    
    func updateDeviceToken(deviceToken: String?) {
        if let deviceTokenStr = deviceToken {
            Defaults[.deviceToken] = deviceTokenStr
        }
    }

    func updateNickname(nickname: String) {
        Defaults[.nickname] = nickname
    }
    
    func getDeviceToken() -> String? {
        return Defaults[.deviceToken]
    }
    
    func getUserInfo() -> [String: String?] {
        var userInfo = Dictionary<String, String?>()
        userInfo["username"] = Defaults[.username]
        userInfo["profileImageURL"] = Defaults[.profileImageURL]
        userInfo["nickname"] = Defaults[.nickname]
        userInfo["token"] = Defaults[.token]
        return userInfo
    }
    
    func getUsername() -> String? {
        let username = Defaults[.username]
        return username
    }

    func getNickname() -> String? {
        let nickname = Defaults[.nickname]
        return nickname
    }
    
    func getToken() -> String {
        let token: String = Defaults[.token]!
        return token
    }

    func getRole() -> String? {
        let role: String? = Defaults[.role]
        return role
    }

    func updateProfile(username: String?, profileImgURL: String?, nickname: String?) {
        Defaults[.username] = username
        Defaults[.profileImageURL] = profileImgURL
        Defaults[.nickname] = nickname
    }

    func updateRole(role: String) {
        Defaults[.role] = role
    }

    func updateToken(token: String) {
        Defaults[.token] = token
    }

    func getProfileImageURL() -> String? {
        let profileImageURL = Defaults[.profileImageURL]
        return profileImageURL
    }

    func updateProfileImageURL(profileImageURL: String?) {
        if let profileImageURL = profileImageURL {
            Defaults[.profileImageURL] = profileImageURL
        }
    }
    
    func removeUserInfo() {
        Defaults[.username] = nil
        Defaults[.profileImageURL] = nil
        Defaults[.nickname] = nil
        Defaults[.token] = nil
        Defaults[.role] = nil
    }
    
    func checkIfLogin() -> Bool {
        var result = false
        let token: String? = Defaults[.token]
        if token != nil {
            result = true
        }
        return result
    }

    func checkIfProfileReady() -> Bool {
        let nickname = Defaults[.nickname]
        let profileImageURL = Defaults[.profileImageURL]
        if nickname == nil || profileImageURL == nil {
            return false
        } else {
            return true
        }
    }
    
}


