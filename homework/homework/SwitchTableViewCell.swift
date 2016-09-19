//
//  SwtichTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    typealias SwitchClosureType = (on: Bool) -> Void
    var switchBlock: SwitchClosureType?

    var switchView: UISwitch?

    override func awakeFromNib() {
        super.awakeFromNib()


        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(title: String, defaultOn: Bool, switchChange: SwitchClosureType) {
        // initiate switch view
        switchView = UISwitch(frame: CGRectZero)
        switchView?.addTarget(self, action: #selector(self.switchChanged), forControlEvents: .ValueChanged)
        self.accessoryView = switchView
        self.selectionStyle = .None

        self.switchBlock = switchChange
        self.textLabel?.text = title
        self.switchView?.on = defaultOn

    }

    @objc private func switchChanged(switchView: UISwitch) {
        self.switchBlock!(on: switchView.on)
    }


}
