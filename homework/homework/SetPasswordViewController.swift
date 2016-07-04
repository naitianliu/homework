//
//  SetPasswordViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MBProgressHUD

class SetPasswordViewController: UIViewController, UITextFieldDelegate {

    let apiURL = APIURL.authPhoneRegister

    let kLocalMessage = [
        1: "密码需至少6位",
        2: "两次输入密码不一致，请重新输入"
    ]

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reinputPasswordTextField: UITextField!

    var phoneNumber: String?
    var verifyCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.delegate = self
        reinputPasswordTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeLoginButtonOnClick(sender: AnyObject) {
        self.performRegister()
    }

    private func performRegister() {
        let password = passwordTextField.text!
        let confirmPassword = reinputPasswordTextField.text!
        if password != confirmPassword {
            AlertHelper(viewController: self).showPromptAlertView(kLocalMessage[2]!)
            passwordTextField.text = nil
            reinputPasswordTextField.text = nil
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let reqData = [
            "phone": phoneNumber!,
            "password": password,
            "code": verifyCode!
        ]
        CallAPIHelper(url: apiURL, data: reqData).POST({ (responseData) in
            // success
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            let errorCode: Int = responseData["error"].intValue
            if errorCode == 0 {
                let token: String = responseData["token"].stringValue
                UserDefaultsHelper().updateToken(token)
                let mainTabBarController = MainTabBarController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = mainTabBarController
            } else {
                let message: String = GlobalConstants.APIErrorMessage[errorCode]!
                AlertHelper(viewController: self).showPromptAlertView(message)
            }
            }) { (error) in
                // error
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                print(error)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTextField {
            let password = passwordTextField.text!
            if self.validatePassword(password) {
                reinputPasswordTextField.becomeFirstResponder()
            }
        } else if textField == reinputPasswordTextField {
            self.performRegister()
        }
        return true
    }

    private func validatePassword(password: String) -> Bool {
        if password.characters.count < 6 {
            AlertHelper(viewController: self).showPromptAlertView(kLocalMessage[1]!)
            return false
        } else {
            return true
        }
    }
}
