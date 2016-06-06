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
        static let viewHeight: CGFloat = 62
        struct ImageName {
            static let bgImage = "mark-actions-view-bg"
        }
    }
    
    var backgroundImageView: UIImageView?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Constant.viewWidth, height: Constant.viewHeight))
        
        if backgroundImageView == nil {
            let bgImage = UIImage(named: Constant.ImageName.bgImage)
            backgroundImageView = UIImageView(frame: self.frame)
            backgroundImageView?.image = bgImage
            addSubview(backgroundImageView!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
