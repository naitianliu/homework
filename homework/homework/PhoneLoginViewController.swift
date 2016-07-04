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
}
