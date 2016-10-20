//
//  AddImageCollectionViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 10/19/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!

    let borderColor: UIColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = borderColor.CGColor
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.containerView.layer.shadowColor = UIColor.lightGrayColor().CGColor
    }

}
