//
//  ImagesCollectionViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 10/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!

    let borderColor: UIColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()

        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = borderColor.CGColor
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.containerView.layer.shadowColor = UIColor.lightGrayColor().CGColor

        self.deleteButton.layer.borderColor = UIColor.redColor().CGColor
        self.deleteButton.layer.borderWidth = 1

    }

    func configurate(image: UIImage) {
        self.imageView.image = image
    }

    @IBAction func deleteButtonOnClick(sender: AnyObject) {
        
    }
}
