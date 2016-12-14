//
//  CallAPIHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/15/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

class CallAPIHelper: NSObject {
    
    var headers:[String: String] = ["Content-Type": "application/json"]
    
    var data:[String:AnyObject]?
    
    var url:String!
    
    var manager:Alamofire.Manager?
    
    typealias CompletionClosureType = (responseData: JSON) -> Void
    typealias ErrorClosureType = (error: NSError) -> Void
    
    init(url:String!, data:[String:AnyObject]?) {
        super.init()
        
        self.url = url
        self.data = data
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil {
            let token:String = UserDefaultsHelper().getToken()
            self.headers["Authorization"] = "Token \(token)"
        }
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let serverTrustPolicy = ServerTrustPolicy.DisableEvaluation
        self.manager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(
            policies: [
                "localhost" : serverTrustPolicy,
                "192.168.1.82" : serverTrustPolicy,
                "hw.knockfuture.com" : serverTrustPolicy]))
        
    }
    
    func POST(completion: CompletionClosureType, errorOccurs: ErrorClosureType) {
        self.manager!.request(.POST, self.url, parameters: self.data, encoding: .JSON, headers: self.headers).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    self.handleError401()
                }
            }
            let result = response.result
            switch result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(responseData: json)
                }
            case .Failure(let error):
                print(error)
                print(self.url)
                errorOccurs(error: error)
            }
        }
    }
    
    func GET(completion: CompletionClosureType, errorOccurs: ErrorClosureType) {
        self.manager!.request(.GET, self.url, parameters: self.data, headers: self.headers).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
            if let statusCode = response.response?.statusCode {
                if statusCode == 401 {
                    self.handleError401()
                }
            }
            let result = response.result
            switch result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(responseData: json)
                }
            case .Failure(let error):
                print(error)
                print(self.url)
                errorOccurs(error: error)
            }
        }
    }

    private func handleError401() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        UserDefaultsHelper().removeUserInfo()
        appDelegate.switchRootVC()
    }
}
