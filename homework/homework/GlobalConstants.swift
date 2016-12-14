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

    static let kRealmSchemaVersion: UInt64 = 7

    static let kProfileImagePlaceholder: UIImage = UIImage(named: "profile-placeholder")!

    static let kProfileImageViewWidthLg: CGFloat = 30
    static let kProfileImageViewWidthMd: CGFloat = 25
    static let kProfileImageViewWidthSm: CGFloat = 20

    static let kScoresMap = [
        0: " E  ",
        1: " D- ",
        2: " D  ",
        3: " D+ ",
        4: " C- ",
        5: " C  ",
        6: " C+ ",
        7: " B- ",
        8: " B  ",
        9: " B+ ",
        10: " A- ",
        11: " A  ",
        12: " A+ ",
    ]

}

let APIEndpoint = "http://192.168.0.119:8004/api/v1"
// let APIEndpoint = "https://hw.knockfuture.com/api/v1"

struct APIURL {
    
    static let getSTSToken = "\(APIEndpoint)/vendors/get_sts_token/"

    static let authPhoneLogin = "\(APIEndpoint)/auth/phone/login/"
    static let authPhoneVerifyCodeSend = "\(APIEndpoint)/auth/phone/verification_code/send/"
    static let authPhoneVerifyCodeVerify = "\(APIEndpoint)/auth/phone/verification_code/verify/"
    static let authPhoneResetPassword = "\(APIEndpoint)/auth/phone/reset_password/"
    static let authPhoneRegister = "\(APIEndpoint)/auth/phone/register/"

    static let authWechatLogin = "\(APIEndpoint)/auth/wechat/login/"

    static let authInvitationCodeGenerate = "\(APIEndpoint)/auth/invitation_code/generate/"
    static let authInvitationCodeValidate = "\(APIEndpoint)/auth/invitation_code/validate/"

    static let authUserProfileUpdate = "\(APIEndpoint)/auth/user/profile/update/"

    static let authDeviceTokenUpdate = "\(APIEndpoint)/auth/device_token/update/"

    static let schoolCreate = "\(APIEndpoint)/school/create/"
    static let schoolClose = "\(APIEndpoint)/school/close/"

    static let classroomCreate = "\(APIEndpoint)/classroom/create/"
    static let classroomGetList = "\(APIEndpoint)/classroom/get_list/"
    static let classroomSearch = "\(APIEndpoint)/classroom/search/"
    static let classroomUpdate = "\(APIEndpoint)/classroom/update/"
    static let classroomClose = "\(APIEndpoint)/classroom/close/"
    static let classroomSendRequest = "\(APIEndpoint)/classroom/send_request/"
    static let classroomApproveRequest = "\(APIEndpoint)/classroom/approve_request/"

    static let homeworkCreate = "\(APIEndpoint)/homework/create/"
    static let homeworkSubmit = "\(APIEndpoint)/homework/submit/"
    static let homeworkGrade = "\(APIEndpoint)/homework/grade/"
    static let homeworkClose = "\(APIEndpoint)/homework/close/"
    static let homeworkGetHomeworkList = "\(APIEndpoint)/homework/get_homework_list/"
    static let homeworkGetSubmissionList = "\(APIEndpoint)/homework/get_submission_list/"
    static let homeworkGetSubmissionInfo = "\(APIEndpoint)/homework/get_submission_info/"

    static let commentCreate = "\(APIEndpoint)/comment/create/"
    static let commentGetList = "\(APIEndpoint)/comment/get_list/"

    static let updateGet = "\(APIEndpoint)/updates/get/"

    static let qaQestionCreate = "\(APIEndpoint)/qa/question/create/"
    static let qaQestionClose = "\(APIEndpoint)/qa/question/close/"
    static let qaQestionGetList = "\(APIEndpoint)/qa/question/get_list/"
    static let qaAnswerCreate = "\(APIEndpoint)/qa/answer/create/"
    static let qaAnswerAgree = "\(APIEndpoint)/qa/answer/agree/"
    static let qaAnswerGetList = "\(APIEndpoint)/qa/answer/get_list/"


}

struct SampleData {
    static let sampleData_Classroom = [
        "classroomName": "暑期英语集训班",
        "schoolName": "Wonderland学科英语",
        "profileImgURLs": [
            "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg",
            "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg",
            "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg"
        ],
        "studentNumber": "6"
    ]
}
