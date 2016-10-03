//
//  PhoneLoginViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MBProgressHUD

class PhoneLoginViewController: UIViewController, UITextFieldDelegate {

    let apiURL = APIURL.authPhoneLogin

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var inputTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginButtonOnClick(sender: AnyObject) {
        self.performLogin()
    }

    @IBAction func registerButtonOnClick(sender: AnyObject) {
        self.showInvitationCodeAlert()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.performLogin()
        return true
    }

    private func performLogin() {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let reqData = ["phone": phoneNumber, "password": password]
        CallAPIHelper(url: apiURL, data: reqData).POST({ (responseData) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            let errorCode: Int = responseData["error"].intValue
            if errorCode == 0 {
                let token: String = responseData["token"].stringValue
                UserDefaultsHelper().updateToken(token)
                if let profile = responseData["profile"].dictionary {
                    let username = profile["user_id"]?.string
                    let imgURL = profile["img_url"]?.string
                    let nickname = profile["nickname"]?.string
                    print(username)
                    print(token)
                    UserDefaultsHelper().updateProfile(username, profileImgURL: imgURL, nickname: nickname)
                }
                let mainTabBarController = MainTabBarController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = mainTabBarController
            } else {
                let message: String = GlobalConstants.APIErrorMessage[errorCode]!
                AlertHelper(viewController: self).showPromptAlertView(message)
            }
            }) { (error) in
                // error
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                print(error)
        }
    }

    private func showInvitationCodeAlert() {
        let alertController = UIAlertController(title: "请输入邀请码", message: "窗外APP仅限 Wonderland梦想英语 学员使用，学员请从Ali老师或Fiona老师处获取邀请码", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            // textfield
            self.inputTextField = textField
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
            self.inputTextField?.resignFirstResponder()
        }))
        alertController.addAction(UIAlertAction(title: "验证邀请码", style: .Destructive, handler: { (action) in
            self.inputTextField?.resignFirstResponder()
            let code = self.inputTextField?.text
            if let code = code {
                self.apiValidateInvitationCode(code)
            }
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func apiValidateInvitationCode(code: String) {
        let url = APIURL.authInvitationCodeValidate
        let data: [String: AnyObject] = [
            "code": code,
            "vendor": "phone"
        ]
        self.showHUD()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let valid = responseData["valid"].boolValue
                if valid {
                    self.performSegueWithIdentifier("PhoneRegisterSegue", sender: nil)
                } else {
                    AlertHelper(viewController: self).showPromptAlertView("邀请码无效，请重试")
                }
            }
        }) { (error) in
            // error
            self.hideHUD()
        }

    }

    private func showHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }

    }

    private func hideHUD() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}
