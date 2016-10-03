//
//  APISchoolCreate.swift
//  homework
//
//  Created by Liu, Naitian on 8/24/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class APISchoolCreate {

    let url = APIURL.schoolCreate

    var vc: AddSchoolViewController!

    init(vc: AddSchoolViewController) {
        self.vc = vc
    }

    func run(name: String, address: String?) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        var data = ["name": name]
        if let address = address {
            data["address"] = address
        }
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // complete
            let errorCode: Int = responseData["error"].intValue
            let timestamp: Int = responseData["timestamp"].intValue
            let schoolUUID: String = responseData["school_uuid"].stringValue
            if errorCode == 0 {
                SchoolModelHelper().add(schoolUUID, name: name, address: address, active: true, timestamp: timestamp)
                self.vc.dismissViewControllerAnimated(true, completion: nil)
            }
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
                AlertHelper(viewController: self.vc).showPromptAlertView("添加学校失败，请稍后重试")

        }

    }

}