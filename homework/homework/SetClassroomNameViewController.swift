//
//  SetClassroomNameViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SetClassroomNameViewController: UIViewController, UITextFieldDelegate {

    typealias CompleteDismissClosureType = (name: String) -> Void

    let kAlertMessage = [
        1: "请输入有效的班级名称"
    ]

    @IBOutlet weak var nameTextField: UITextField!

    var classroomName: String?

    var completeDismissBlock: CompleteDismissClosureType?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonOnClick(sender: AnyObject) {
        self.performDone()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.performDone()
        return true
    }

    private func performDone() {
        let text = nameTextField.text!
        if text == "" {
            AlertHelper(viewController: self).showPromptAlertView(kAlertMessage[1]!)
            return
        }
        self.dismissViewControllerAnimated(false) {
            self.classroomName = text
            self.completeDismissBlock!(name: self.classroomName!)
        }
    }

}
