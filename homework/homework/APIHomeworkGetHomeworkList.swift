//
//  APIHomeworkGetHomeworkList.swift
//  homework
//
//  Created by Liu, Naitian on 9/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

class APIHomeworkGetHomeworkList {

    let url = APIURL.homeworkGetHomeworkList

    let role: String = UserDefaultsHelper().getRole()!

    let Keys = GlobalKeys.HomeworkKeys.self

    var vc: ClassroomDetailViewController!

    init(vc: ClassroomDetailViewController) {
        self.vc = vc
    }

    func run(classroomUUID: String) {
        MBProgressHUD.showHUDAddedTo(self.vc.view, animated: true)
        let data = [
            "role": role,
            self.Keys.classroomUUID: classroomUUID
        ]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success
            MBProgressHUD.hideHUDForView(self.vc.view, animated: true)
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.vc.view, animated: true)

        }

    }
}