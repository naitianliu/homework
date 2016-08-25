//
//  AlertViewHelper.swift
//  homework
//
//  Created by Liu, Naitian on 7/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {

    private let kAlertTitle = "提示"
    private let kAlertCancelButtonTitle = "知道了"

    private var viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showPromptAlertView(message: String) {
        let alertController = UIAlertController(title: kAlertTitle, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: kAlertCancelButtonTitle, style: .Cancel, handler: nil))
        self.viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}