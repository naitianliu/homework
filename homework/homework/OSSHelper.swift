//
//  OSSHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/15/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import AliyunOSSiOS

class OSSHelper {
    
    typealias TokenObtainedClosureType = (stsToken: [String: String]) -> Void
    
    struct Constant {
        static let bucketName = "hw-audio"
        static let OSS_Endpoint = "oss-cn-shanghai.aliyuncs.com"
    }
    
    let userDefaultsHelper = UserDefaultsHelper()
    var client: OSSClient?
    
    init() {
        self.getSTSToken { (stsToken) in
            let credential = OSSStsTokenCredentialProvider(accessKeyId: stsToken["accessKeyId"], secretKeyId: stsToken["accessKeySecret"], securityToken: stsToken["securityToken"])
            self.client = OSSClient(endpoint: Constant.OSS_Endpoint, credentialProvider: credential)
        }
    }
    
    func getSTSToken(tokenObtained: TokenObtainedClosureType) {
        if let credentials = self.userDefaultsHelper.getSTSCredentials() {
            tokenObtained(stsToken: credentials)
        } else {
            CallAPIHelper(url: APIURL.getSTSToken, data: nil).GET({ (responseData) in
                let stsAccessKeyId = responseData["AccessKeyId"].string!
                let stsAccessKeySecret = responseData["AccessKeySecret"].string!
                let stsSecurityToken = responseData["SecurityToken"].string!
                let stsExpiration = responseData["Expiration"].string!
                self.userDefaultsHelper.setSTSCredentials(stsAccessKeyId, stsAccessKeySecret: stsAccessKeySecret, stsSecurityToken: stsSecurityToken, stsExpiration: stsExpiration)
                let credentials = self.userDefaultsHelper.getSTSCredentials()
                tokenObtained(stsToken: credentials!)
                }, errorOccurs: { (error) in
                    // error
            })
        }
    }
    
    func uploadFile(filepath: String, objectKey: String) {
        let put = OSSPutObjectRequest()
        put.bucketName = Constant.bucketName
        put.objectKey = objectKey
        put.uploadingFileURL = NSURL(fileURLWithPath: filepath)
        let putTask: OSSTask? = self.client?.putObject(put)
        putTask?.continueWithBlock({ (task) -> AnyObject? in
            if (task.error == nil) {
                print("upload object success")
            } else {
                print("upload object failed error: \(task.error)")
            }
            return nil
        })
    }
}