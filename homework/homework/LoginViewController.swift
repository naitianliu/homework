//
//  LoginViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Diplomat
import MBProgressHUD

class LoginViewController: UIViewController {

    var inputTextField: UITextField?
    var username: String?
    var uid: String?
    var token: String?
    var nickname: String?
    var imgURL: String?

    let userDefaultHelper = UserDefaultsHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func wechatLoginButtonOnClick(sender: AnyObject) {
        Diplomat.sharedInstance().authWithName(kDiplomatTypeWechat) { (result, error) in
            if let result = result {
                let uid = result.uid!
                self.uid = uid
                let nickname = result.nick!
                self.nickname = nickname
                let profileImgURL = result.avatar!!
                self.imgURL = profileImgURL
                let data: [String: AnyObject] = [
                    "uid": uid,
                    "nickname": nickname,
                    "img_url": profileImgURL
                ]
                let url = APIURL.authWechatLogin
                self.showHUD()
                CallAPIHelper(url: url, data: data).POST({ (responseData) in
                    // success
                    self.hideHUD()
                    let errorCode = responseData["error"].intValue
                    if errorCode == 0 {
                        self.username = responseData["username"].stringValue
                        self.token = responseData["token"].stringValue
                        let active = responseData["active"].boolValue
                        if active {
                            self.performLogin()
                        } else {
                            self.showInvitationCodeAlert()
                        }
                    }
                    }, errorOccurs: { (error) in
                        // error
                        self.hideHUD()
                        AlertHelper(viewController: self).showPromptAlertView("登录出现异常，请稍后重试")
                })
            }
        }
    }

    private func performLogin() {
        self.userDefaultHelper.updateToken(self.token!)
        self.userDefaultHelper.updateProfile(self.username!, profileImgURL: self.imgURL!, nickname: self.nickname!)
        let mainTabBarController = MainTabBarController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = mainTabBarController
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
            "uid": self.uid!,
            "code": code,
            "username": self.username!,
            "vendor": "wechat"
        ]
        self.showHUD()
        CallAPIHelper(url: url, data: data).POST({ (responseData) in
            // success
            self.hideHUD()
            let errorCode = responseData["error"].intValue
            if errorCode == 0 {
                let valid = responseData["valid"].boolValue
                if valid {
                    self.performLogin()
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
