//
//  AppDelegate.swift
//  homework
//
//  Created by Liu, Naitian on 6/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Diplomat
import KDEAudioPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = GlobalConstants.themeColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        Diplomat.sharedInstance().registerWithConfigurations([kDiplomatTypeWechat: [kDiplomatAppIdKey: GlobalConstants.Weixin.appId, kDiplomatAppSecretKey: GlobalConstants.Weixin.appSecret]])
        
        switchRootVC()

        PerformMigrations().migrate()

        PerformMigrations().setDefaultRealmForUser()

        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil))
        UIApplication.sharedApplication().registerForRemoteNotifications()

        application.beginReceivingRemoteControlEvents()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenString = self.dataToHex(deviceToken)
        print(deviceTokenString)
        UserDefaultsHelper().updateDeviceToken(deviceTokenString)
        APIDeviceTokenUpdate().run()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return Diplomat.sharedInstance().handleOpenURL(url)
    }

    func didLogin() {
        self.switchRootVC()
    }

    func switchRootVC() {
        let isLogin = UserDefaultsHelper().checkIfLogin()
        if isLogin {
            let mainTabBarController = MainTabBarController()
            self.window?.rootViewController = mainTabBarController
        } else {
            let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let authNC = authStoryboard.instantiateViewControllerWithIdentifier("AuthNC") as! UINavigationController
            self.window?.rootViewController = authNC
        }
    }

    private func dataToHex(data: NSData) -> String {
        var str: String = String()
        let p = UnsafePointer<UInt8>(data.bytes)
        let len = data.length
        for i in 0 ..< len {
            str += String(format: "%02.2X", p[i])
        }
        return str
    }

}

