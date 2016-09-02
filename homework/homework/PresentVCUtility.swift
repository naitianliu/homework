//
//  PresentVCUtility.swift
//  homework
//
//  Created by Liu, Naitian on 8/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class PresentVCUtility {

    var vc: UIViewController?
    let homeworkSB = UIStoryboard(name: "Homework", bundle: nil)

    init(vc: UIViewController?) {
        self.vc = vc
    }

    func showSelectHWTypeVC() {
        let selectHWTypeVC = homeworkSB.instantiateViewControllerWithIdentifier("SelectHWTypeViewController") as! SelectHWTypeViewController
        selectHWTypeVC.modalPresentationStyle = .OverFullScreen
        self.vc?.presentViewController(selectHWTypeVC, animated: true, completion: nil)
    }

    
}