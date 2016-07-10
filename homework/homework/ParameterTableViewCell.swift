//
//  ParameterTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ParameterTableViewCell: UITableViewCell {

    init() {
        super.init(style: .Value1, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(title: String?, value: String?) {
        self.selectionStyle = .Gray
        self.accessoryType = .DisclosureIndicator
        if let title = title {
            self.textLabel?.text = title
        } else {
            self.textLabel?.text = "未知"
        }
        if let value = value {
            self.detailTextLabel?.text = value
        } else {
            self.detailTextLabel?.text = "未填写"
        }


    }

}
