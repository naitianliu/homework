//
//  InputTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!

    typealias ReturnValueClosureType = (value: String) -> Void
    var returnValueBlock: ReturnValueClosureType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(placeholder: String?, returnValueBlock: ReturnValueClosureType) {
        inputTextField.placeholder = placeholder
        if inputTextField.text! == "" {
            inputTextField.becomeFirstResponder()
        } else {
            inputTextField.resignFirstResponder()
        }
        self.returnValueBlock = returnValueBlock

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.performReturn()
        return true
    }

    func textFieldDidChange(textField: UITextField) {
        let text = inputTextField.text!
        print(text)
        self.returnValueBlock!(value: text)
    }

    private func performReturn() {
        let text = inputTextField.text!
        self.returnValueBlock!(value: text)
        inputTextField.resignFirstResponder()
    }
    
}
