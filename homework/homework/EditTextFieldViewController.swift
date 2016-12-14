//
//  EditTextFieldViewController.swift
//  homework
//
//  Created by Liu, Naitian on 12/14/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class EditTextFieldViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!

    var navTitle: String?
    var contentText: String?
    var placeholder: String?

    typealias CompleteClosureType = (text: String) -> Void
    var completeBlock: CompleteClosureType?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initiateConfirmButton()

        self.textField.delegate = self

        self.textField.text = self.contentText
        self.textField.placeholder = placeholder
        if let navTitle = navTitle {
            self.navigationItem.title = navTitle
        } else {
            self.navigationItem.title = "编辑内容"
        }

        self.textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func completeBlockSetter(complete: CompleteClosureType) {
        self.completeBlock = complete
    }

    func initiateConfirmButton() {
        let confirmButton = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(self.confirmButtonOnClick))
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    func confirmButtonOnClick(sender: AnyObject) {
        if let text = self.textField.text {
            self.completeBlock!(text: text)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            AlertHelper(viewController: self).showPromptAlertView("内容不能为空")
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }


}
