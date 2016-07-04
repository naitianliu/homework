//
//  PhoneRegisterViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import MBProgressHUD

class PhoneRegisterViewController: UIViewController {

    let apiURL = APIURL.authPhoneVerifyCodeSend

    let kLocalMessage = [
        1: "验证码已发送，请查看短信",
        2: "请输入有效手机号码",
        3: "请输入验证码"
    ]

    let kSegueIdentifier = "RegisterSetPasswordSegue"

    var phoneNumber: String?
    var verifyCode: String?

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func obtainCodeButtonOnClick(sender: AnyObject) {
        self.performObtainCode()
    }

    @IBAction func nextButtonOnClick(sender: AnyObject) {
        self.performNextStep()
    }

    private func performObtainCode() {
        let phoneNumber = phoneNumberTextField.text!
        if phoneNumber == "" {
            AlertHelper(viewController: self).showPromptAlertView(kLocalMessage[2]!)
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        CallAPIHelper(url: apiURL, data: ["phone": phoneNumber]).POST({ (responseData) in
            // success
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                AlertHelper(viewController: self).showPromptAlertView(self.kLocalMessage[1]!)
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

    private func performNextStep() {
        phoneNumber = phoneNumberTextField.text!
        verifyCode = verifyCodeTextField.text!
        if phoneNumber == "" {
            AlertHelper(viewController: self).showPromptAlertView(self.kLocalMessage[2]!)
            return
        }
        if verifyCode == "" {
            AlertHelper(viewController: self).showPromptAlertView(self.kLocalMessage[3]!)
            return
        }
        self.performSegueWithIdentifier(kSegueIdentifier, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegueIdentifier {
            let setPasswordVC = segue.destinationViewController as! SetPasswordViewController
            setPasswordVC.phoneNumber = phoneNumber
            setPasswordVC.verifyCode = verifyCode
        }
    }
}
