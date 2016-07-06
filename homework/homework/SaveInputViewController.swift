//
//  SaveInputViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

protocol SaveInputVCDelegate {
    func didFinishedInputToSave(input: String)
}

class SaveInputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputTextField: UITextField!

    var inputText: String?
    var navbarTitle: String?

    var delegate: SaveInputVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self

        if let inputText = inputText {
            inputTextField.text = inputText
        }
        inputTextField.becomeFirstResponder()

        if let navbarTitle = navbarTitle {
            self.navigationItem.title = navbarTitle
        } else {
            self.navigationItem.title = "设置参数"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonOnClick(sender: AnyObject) {
        self.finishInput()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.finishInput()
        return true
    }

    private func finishInput() {
        let text = inputTextField.text!
        if text == "" { return }
        self.navigationController?.popViewControllerWithCompletion(true, complete: { 
            self.delegate?.didFinishedInputToSave(text)
        })
    }

}
