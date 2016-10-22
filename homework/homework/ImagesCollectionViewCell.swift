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

    typealias DeleteClosureType = () -> Void
    var deleteBlock: DeleteClosureType?

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

    func configurate(image: UIImage, delete: DeleteClosureType) {
        self.imageView.image = image
        self.deleteBlock = delete
    }

    @IBAction func deleteButtonOnClick(sender: AnyObject) {
        if let deleteBlock = self.deleteBlock {
            deleteBlock()
        }
    }

}
