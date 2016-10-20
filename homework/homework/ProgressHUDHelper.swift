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

    var hud: MBProgressHUD!

    init(view: UIView) {
        self.view = view
    }

    func show() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
    }

    func showWithTitle(title: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.hud.label.text = title
        }
    }

    func updateSubtitle(subtitle: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.hud.detailsLabel.text = subtitle
        }
    }

    func hide() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}
