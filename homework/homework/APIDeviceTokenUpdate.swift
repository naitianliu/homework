//
//  APIDeviceTokenUpdate.swift
//  homework
//
//  Created by Liu, Naitian on 9/12/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class APIDeviceTokenUpdate {

    let url = APIURL.authDeviceTokenUpdate

    let username = UserDefaultsHelper().getUsername()
    let deviceToken = UserDefaultsHelper().getDeviceToken()

    init() {

    }

    func run() {
        if let username = username, let deviceToken = deviceToken {
            let data: [String: AnyObject] = [
                "device_token": deviceToken
            ]
            CallAPIHelper(url: self.url, data: data).POST({ (responseData) in
                // success
                print(responseData)
                }, errorOccurs: { (error) in
                    // error
            })
        }
    }

}