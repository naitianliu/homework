//
//  ProgressHUDHelper.swift
//  homework
//
//  Created by Liu, Naitian on 7/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit

class ProgressHUDHelper {

    var view: UIView!

    init(view: UIView) {
        self.view = view
    }

    func show() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }

    func hide() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
        })
    }
}