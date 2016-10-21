//
//  FileHelper.swift
//  homework
//
//  Created by Liu, Naitian on 7/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import UIKit


class FileHelper {
    init() {

    }

    func saveImageToFile(image: UIImage, objectKey: String) -> String? {
        let filepath: String = "\(getDocumentsDirectory())/\(objectKey)-image.png"
        do {
            try UIImagePNGRepresentation(image)?.writeToFile(filepath, options: .AtomicWrite)
            return filepath
        } catch {
            print(error)
            return nil
        }
    }

    func saveCompressedJPEGImageToFile(image: UIImage, objectKey: String) -> String? {
        let newImage = self.resizeImage(image, newWidth: 500)
        let filepath: String = "\(getDocumentsDirectory())/\(objectKey)-image.jpg"
        do {
            try UIImageJPEGRepresentation(newImage, 0.5)?.writeToFile(filepath, options: .AtomicWrite)
            return filepath
        } catch {
            print(error)
            return nil
        }
    }

    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        print(image.size.width)
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}