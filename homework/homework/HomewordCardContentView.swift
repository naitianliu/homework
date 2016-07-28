//
//  HomewordCardContentView.swift
//  homework
//
//  Created by Liu, Naitian on 7/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class HomewordCardContentView: UIView {

    @IBOutlet weak var sampleLabel: UILabel!

    func configurate(sample: String) {
        sampleLabel.text = sample
    }

}
