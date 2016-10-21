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

    typealias CompletionClosureType = () -> Void

    init(vc: UIViewController?) {
        self.vc = vc
    }

    func showSelectHWTypeVC(classroomUUID: String?, completion: CompletionClosureType?) {
        let selectHWTypeVC = homeworkSB.instantiateViewControllerWithIdentifier("SelectHWTypeViewController") as! SelectHWTypeViewController
        selectHWTypeVC.selectedClassroomUUID = classroomUUID
        selectHWTypeVC.completionBlock = completion
        selectHWTypeVC.modalPresentationStyle = .OverFullScreen
        self.vc?.presentViewController(selectHWTypeVC, animated: true, completion: nil)
    }
    
}