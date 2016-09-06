//
//  ActionButtonTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ActionButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var button: UIButton!

    typealias ClickActionClosureType = () -> Void
    var clickActionBlock: ClickActionClosureType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderBgView()
    }

    private func renderBgView() {
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.bgView.layer.masksToBounds = true
    }

    func configurate(btnTitle: String, bgColor: UIColor?, action: ClickActionClosureType) {
        self.clickActionBlock = action
        self.bgView.backgroundColor = bgColor
        self.button.setTitle(btnTitle, forState: .Normal)
        self.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.button.addTarget(self, action: #selector(self.buttonOnClick), forControlEvents: .TouchUpInside)

    }

    @objc private func buttonOnClick(sender: AnyObject!) {
        self.clickActionBlock!()
    }
    
}
