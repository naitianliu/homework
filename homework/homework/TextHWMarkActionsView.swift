//
//  TextHWMarkActionsView.swift
//  homework
//
//  Created by Liu, Naitian on 6/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TextHWMarkActionsView: UIView {
    struct Constant {
        static let viewWidth: CGFloat = 170
        static let viewHeight: CGFloat = 64
        static let buttonWidth: CGFloat = 35
        static let space_x: CGFloat = 28
        static let space_y: CGFloat = 15
        struct ImageName {
            static let bgImage = "mark-actions-view-bg"
            static let eraserButton = "button-eraser"
            static let microphoneButton = "button-microphone"
        }
    }
    
    var backgroundImageView: UIImageView?
    var eraserButton: UIButton!
    var microphoneButton: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Constant.viewWidth, height: Constant.viewHeight))
        
        if backgroundImageView == nil {
            let bgImage = UIImage(named: Constant.ImageName.bgImage)
            backgroundImageView = UIImageView(frame: self.frame)
            backgroundImageView?.image = bgImage
            addSubview(backgroundImageView!)
        }
        
        eraserButton = UIButton(frame: CGRect(x: Constant.space_x, y: Constant.space_y, width: Constant.buttonWidth, height: Constant.buttonWidth))
        let x_mb = Constant.viewWidth - Constant.space_x - Constant.buttonWidth
        let y_mb = Constant.space_y
        microphoneButton = UIButton(frame: CGRect(x: x_mb, y: y_mb, width: Constant.buttonWidth, height: Constant.buttonWidth))
        eraserButton.setBackgroundImage(UIImage(named: Constant.ImageName.eraserButton), forState: .Normal)
        microphoneButton.setBackgroundImage(UIImage(named: Constant.ImageName.microphoneButton), forState: .Normal)
        addSubview(eraserButton)
        addSubview(microphoneButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
