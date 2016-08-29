//
//  APIClassroomGetList.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class APIClassroomGetList {

    let url = APIURL.classroomGetList

    let role = UserDefaultsHelper().getRole()!

    var vc: ClassroomViewController!

    init(vc: ClassroomViewController) {
        self.vc = vc
    }

    func run() {
        let data = ["role": "t"]
        CallAPIHelper(url: url, data: data).GET({ (responseData) in
            // success

            }) { (error) in
                // error
                
        }
    }
}