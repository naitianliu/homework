//
//  SelectHWTypeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/31/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SelectHWTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.renderBlurBackground()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func renderBlurBackground() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.frame
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.insertSubview(blurEffectView, atIndex: 0)
        }
    }

}
