//
//  ProfileUpdateHelper.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class ProfileUpdateHelper {

    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var vc: UIViewController?

    init(vc: UIViewController?) {
        self.vc = vc
    }

    func switchRole() {
        let roleSelectionVC = RoleSelectionViewController(nibName: "RoleSelectionViewController", bundle: nil)
        roleSelectionVC.modalTransitionStyle = .CrossDissolve
        dispatch_async(dispatch_get_main_queue()) {
            self.vc?.presentViewController(roleSelectionVC, animated: true, completion: nil)
        }
    }

    func logout() {
        UserDefaultsHelper().removeUserInfo()
        appDelegate.switchRootVC()
    }

}