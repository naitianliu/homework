//
//  ImageHelper.swift
//  homework
//
//  Created by Liu, Naitian on 7/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {

    struct Constant {
        static let kAvatarImageWidth: CGFloat = 100
    }

    init() {

    }

    func resizeAvatarImage(image: UIImage) -> UIImage {
        return self.resizeImage(image, newWidth: Constant.kAvatarImageWidth)
    }

    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let oldWidth = image.size.width
        if newWidth < oldWidth {
            let scale = newWidth / oldWidth
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
            image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        } else {
            return image
        }
    }
}