//
//  EditTextFieldTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 12/14/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class EditTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextField!

    typealias CompleteEditClosureType = (text: String) -> Void
    var completeEditBlock: CompleteEditClosureType?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);

        self.textfield.delegate = self

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(text: String?, placeholder: String?, completeEdit: CompleteEditClosureType) {
        self.textfield.text = text
        self.textfield.placeholder = placeholder
        self.completeEditBlock = completeEdit
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textfield.resignFirstResponder()
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(string)
        print(textField.text)
        if let text = textField.text {
            self.completeEditBlock!(text: text)
        }
        return true
    }


    
}
