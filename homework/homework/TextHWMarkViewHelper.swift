//
//  TextHWMarkViewHelper.swift
//  homework
//
//  Created by Liu, Naitian on 6/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class TextHWMarkViewHelper: NSObject {
    struct Constant {
        static let markButtonWidth: CGFloat = 50
        static let markButtonGap: CGFloat = 10
        
        struct ImageName {
            static let markSelectionCenter = "mark-selection-center"
            static let markSelectionCheck = "mark-selection-check"
            static let markSelectionCircle = "mark-selection-circle"
            static let markSelectionTimes = "mark-selection-times"
            static let markCheck = "mark-check"
            static let markCircle = "mark-circle"
            static let markTimes = "mark-times"
        }
    }
    
    var svContentView: UIView!
    
    var markButtonArray = [UIButton]()
    
    var markSelectionButtonCenter: UIButton!
    var markSelectionButtonCheck: UIButton!
    var markSelectionButtonCircle: UIButton!
    var markSelectionButtonTimes: UIButton!
    
    var markSelectionButtonsShown: Bool = false
    
    var markActionsView = TextHWMarkActionsView()
    
    init(svContentView: UIView) {
        super.init()
        
        self.svContentView = svContentView
        self.initMarkSelectionButtons()
        self.initMarkActionsView()
    }
    
    func addMark(center: CGPoint) {
        if markSelectionButtonsShown {
            self.hideMarkSelectionButtons(true)
        } else {
            self.slideMarkSelectionButtons(center)
        }
    }
    
    private func initMarkActionsView() {
        self.markActionsView.hidden = true
        self.svContentView.addSubview(self.markActionsView)
    }
    
    private func initMarkSelectionButtons() {
        let width = Constant.markButtonWidth
        let height = Constant.markButtonWidth
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        markSelectionButtonCenter = UIButton(frame: frame)
        markSelectionButtonCheck = UIButton(frame: frame)
        markSelectionButtonCircle = UIButton(frame: frame)
        markSelectionButtonTimes = UIButton(frame: frame)
        markSelectionButtonCenter.setBackgroundImage(UIImage(named: Constant.ImageName.markSelectionCenter), forState: .Normal)
        markSelectionButtonCheck.setBackgroundImage(UIImage(named: Constant.ImageName.markSelectionCheck), forState: .Normal)
        markSelectionButtonCircle.setBackgroundImage(UIImage(named: Constant.ImageName.markSelectionCircle), forState: .Normal)
        markSelectionButtonTimes.setBackgroundImage(UIImage(named: Constant.ImageName.markSelectionTimes), forState: .Normal)
        self.svContentView.addSubview(markSelectionButtonCenter)
        self.svContentView.addSubview(markSelectionButtonCheck)
        self.svContentView.addSubview(markSelectionButtonCircle)
        self.svContentView.addSubview(markSelectionButtonTimes)
        markSelectionButtonCenter.tag = 0
        markSelectionButtonCheck.tag = 1
        markSelectionButtonCircle.tag = 2
        markSelectionButtonTimes.tag = 3
        markSelectionButtonCenter.addTarget(self, action: #selector(self.markSelectionButtonOnClick), forControlEvents: .TouchDown)
        markSelectionButtonCheck.addTarget(self, action: #selector(self.markSelectionButtonOnClick), forControlEvents: .TouchDown)
        markSelectionButtonCircle.addTarget(self, action: #selector(self.markSelectionButtonOnClick), forControlEvents: .TouchDown)
        markSelectionButtonTimes.addTarget(self, action: #selector(self.markSelectionButtonOnClick), forControlEvents: .TouchDown)
        self.hideMarkSelectionButtons(true)
    }
    
    private func slideMarkSelectionButtons(center: CGPoint) {
        self.hideMarkSelectionButtons(false)
        let width = Constant.markButtonWidth
        let height = Constant.markButtonWidth
        let x = center.x - width / 2
        let y = center.y - height / 2
        let startRect = CGRect(x: x, y: y, width: width, height: height)
        self.animateSelectionButtons(startRect)
        markSelectionButtonsShown = true
        self.hideMarkActionsView()
    }
    
    private func hideMarkSelectionButtons(hidden: Bool) {
        markSelectionButtonCenter.hidden = hidden
        markSelectionButtonCheck.hidden = hidden
        markSelectionButtonCircle.hidden = hidden
        markSelectionButtonTimes.hidden = hidden
        markSelectionButtonsShown = false
    }
    
    private func animateSelectionButtons(startRect: CGRect) {
        markSelectionButtonCenter.frame = startRect
        markSelectionButtonCheck.frame = startRect
        markSelectionButtonCircle.frame = startRect
        markSelectionButtonTimes.frame = startRect
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.markSelectionButtonCheck.frame.origin.x = startRect.origin.x - Constant.markButtonWidth - Constant.markButtonGap
            self.markSelectionButtonCircle.frame.origin.x = startRect.origin.x + Constant.markButtonWidth + Constant.markButtonGap
            self.markSelectionButtonTimes.frame.origin.y = startRect.origin.y + Constant.markButtonWidth + Constant.markButtonGap
            }) { (finished) in
                if finished {
                    
                }
        }
    }
    
    func markSelectionButtonOnClick(sender: UIButton) {
        let tags = [1, 2, 3]
        if  tags.contains(sender.tag) {
            let markButton = UIButton(frame: markSelectionButtonCenter.frame)
            switch sender.tag {
            case 1:
                markButton.setBackgroundImage(UIImage(named: Constant.ImageName.markCheck), forState: .Normal)
                markButton.tag = 11
                break
            case 2:
                markButton.setBackgroundImage(UIImage(named: Constant.ImageName.markCircle), forState: .Normal)
                markButton.tag = 12
                break
            case 3:
                markButton.setBackgroundImage(UIImage(named: Constant.ImageName.markTimes), forState: .Normal)
                markButton.tag = 13
                break
            default:
                break
            }
            markButton.addTarget(self, action: #selector(self.markButtonOnClick), forControlEvents: .TouchDown)
            self.svContentView.addSubview(markButton)
            self.markButtonArray.append(markButton)
            self.hideMarkSelectionButtons(true)
        }
    }
    
    private func hideMarkActionsView() {
        self.markActionsView.hidden = true
    }
    
    private func showMarkActionsView() {
        if self.markActionsView.hidden {
            self.markActionsView.hidden = false
        } else {
            self.markActionsView.hidden = true
        }
    }
    
    func hideAll() {
        self.hideMarkSelectionButtons(true)
        self.hideMarkActionsView()
    }
    
    func markButtonOnClick(sender: UIButton) {
        let x = sender.frame.origin.x
        let y = sender.frame.origin.y
        self.markActionsView.frame.origin.x = x + Constant.markButtonWidth
        self.markActionsView.frame.origin.y = y
        self.hideMarkSelectionButtons(true)
        self.showMarkActionsView()
    }
}
