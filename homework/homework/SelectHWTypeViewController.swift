//
//  SelectHWTypeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SelectHWTypeViewController: UIViewController {

    let kIconImageNames = ["homework-type-1", "homework-type-2", "homework-type-3", "homework-type-4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.renderBlurBackground()
        self.setupHomeworkTypeButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func renderBlurBackground() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            let blurEffect = UIBlurEffect(style: .ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.frame
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.insertSubview(blurEffectView, atIndex: 0)
        }
    }

    private func setupHomeworkTypeButtons() {
        let buttonFrameRects = self.getHomeworkTypeButtonsRect()
        for i in 0...3 {
            let button = UIButton(frame: buttonFrameRects[i])
            button.imageView?.contentMode = .ScaleAspectFit
            button.setImage(UIImage(named: kIconImageNames[i]), forState: .Normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.homeworkTypeButtonOnClick), forControlEvents: .TouchUpInside)
            self.view.addSubview(button)
        }
    }

    private func getHomeworkTypeButtonsRect() -> [CGRect] {
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        let paddingBottom: CGFloat = 200
        let paddingLeft: CGFloat = 50
        let gapVertical: CGFloat = 40
        let gapHorizontal: CGFloat = 50
        let btnWidth = (viewWidth - paddingLeft * 2 - gapHorizontal) / 2
        let btnFrame1 = CGRect(x: paddingLeft, y: viewHeight - btnWidth * 2 - paddingBottom - gapVertical, width: btnWidth, height: btnWidth)
        let btnFrame2 = CGRect(x: btnFrame1.origin.x + btnWidth + gapHorizontal, y: btnFrame1.origin.y, width: btnWidth, height: btnWidth)
        let btnFrame3 = CGRect(x: btnFrame1.origin.x, y: btnFrame1.origin.y + btnWidth + gapVertical, width: btnWidth, height: btnWidth)
        let btnFrame4 = CGRect(x: btnFrame2.origin.x, y: btnFrame3.origin.y, width: btnWidth, height: btnWidth)
        return [btnFrame1, btnFrame2, btnFrame3, btnFrame4]
    }

    func homeworkTypeButtonOnClick(sender: UIButton!) {
        print(sender.tag)
    }

    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 

        }
    }

}
