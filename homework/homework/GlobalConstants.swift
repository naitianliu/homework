//
//  GlobalConstants.swift
//  homework
//
//  Created by Liu, Naitian on 6/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    static let themeColor = UIColor(red: 90/255, green: 210/255, blue: 185/255, alpha: 1)
    static let backButtonTitle = "返回"
}

let APIEndpoint = "http://localhost:8000"

struct APIURL {
    
    static let getSTSToken = "\(APIEndpoint)/api/v1/vendors/get_sts_token/"
}
