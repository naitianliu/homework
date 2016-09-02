//
//  APIHomeworkCreate.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIHomeworkCreate {

    let url = APIURL.homeworkCreate

    let role: String = UserDefaultsHelper().getRole()!

    let Keys = GlobalKeys.HomeworkKeys.self

    var vc: UIViewController!
    
    init(vc: UIViewController!) {
        self.vc = vc
    }

    func run(classroomUUID: String, info: [String: AnyObject]) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        let data: [String: AnyObject] = [
            Keys.classroomUUID: classroomUUID,
            "role": role,
            "info": info
        ]
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
        }
    }
}