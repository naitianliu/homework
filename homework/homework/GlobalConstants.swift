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
    
    struct Weixin {
        static let appId = "wxaf15e2cba7d87936"
        static let appSecret = "05aa0f9946b7ec9f587acf476373e103"
    }

    static let APIErrorMessage = [
        1010: "该号码还没有注册",
        1011: "密码不正确，请重新输入",
        1020: "每天最多可以发送五次验证码",
        1050: "该手机号码已被注册",
        1051: "验证码错误或已过期，请返回重新获取验证码",
    ]

    static let kRealmSchemaVersion: UInt64 = 2

    static let kProfileImagePlaceholder: UIImage = UIImage(named: "profile-placeholder")!

}

let APIEndpoint = "http://localhost:8000/api/v1"

struct APIURL {
    
    static let getSTSToken = "\(APIEndpoint)/vendors/get_sts_token/"

    static let authPhoneLogin = "\(APIEndpoint)/auth/phone/login/"
    static let authPhoneVerifyCodeSend = "\(APIEndpoint)/auth/phone/verification_code/send/"
    static let authPhoneVerifyCodeVerify = "\(APIEndpoint)/auth/phone/verification_code/verify/"
    static let authPhoneResetPassword = "\(APIEndpoint)/auth/phone/reset_password/"
    static let authPhoneRegister = "\(APIEndpoint)/auth/phone/register/"
    static let authUserProfileUpdate = "\(APIEndpoint)/auth/user/profile/update/"

    static let schoolCreate = "\(APIEndpoint)/school/create/"

    static let classroomCreate = "\(APIEndpoint)/classroom/create/"
    static let classroomGetList = "\(APIEndpoint)/classroom/get_list/"

}
