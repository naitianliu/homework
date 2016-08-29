//
//  UINavigationController.swift
//  homework
//
//  Created by Liu, Naitian on 7/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    typealias CompletionClosureType = () -> Void

    func popViewControllerWithCompletion(animated: Bool, complete: CompletionClosureType) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { 
            complete()
        }
        self.popViewControllerAnimated(animated)
        CATransaction.commit()
    }
}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}