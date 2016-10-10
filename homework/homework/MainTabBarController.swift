//
//  MainTabBarController.swift
//  homework
//
//  Created by Liu, Naitian on 6/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
    let classroomStoryboard = UIStoryboard(name: "Classroom", bundle: nil)
    let qaStoryboard = UIStoryboard(name: "QA", bundle: nil)
    let meStoryboard = UIStoryboard(name: "Me", bundle: nil)
    
    var homeNC: UINavigationController!
    var classroomNC: UINavigationController!
    var qaNC: UINavigationController!
    var meNC: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.tintColor = GlobalConstants.themeColor
        
        homeNC = homeStoryboard.instantiateViewControllerWithIdentifier("HomeNC") as! UINavigationController
        homeNC.tabBarItem.title = "首页"
        homeNC.tabBarItem.image = UIImage(named: "tab-home")
        let homeVC: HomeViewController = homeNC.viewControllers[0] as! HomeViewController
        homeVC.createClassroomBlock = { () in
            self.createClassroom()
        }
        
        classroomNC = classroomStoryboard.instantiateViewControllerWithIdentifier("ClassroomNC") as! UINavigationController
        classroomNC.tabBarItem.title = "班级"
        classroomNC.tabBarItem.image = UIImage(named: "tab-classroom")
        
        qaNC = qaStoryboard.instantiateViewControllerWithIdentifier("QANavigationController") as! UINavigationController
        qaNC.tabBarItem.title = "问答"
        qaNC.tabBarItem.image = UIImage(named: "tab-question")
        
        meNC = meStoryboard.instantiateViewControllerWithIdentifier("MeNC") as! UINavigationController
        meNC.tabBarItem.title = "我"
        meNC.tabBarItem.image = UIImage(named: "tab-me")
        
        self.viewControllers = [homeNC, classroomNC, qaNC, meNC]

        showSelectRoleVC()

        showUpdateProfileNC()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showUpdateProfileNC() {
        if UserDefaultsHelper().checkIfProfileReady() { return }
        let updateProfileNC = meStoryboard.instantiateViewControllerWithIdentifier("UpdateProfileNC") as! UINavigationController
        updateProfileNC.modalTransitionStyle = .CoverVertical
        dispatch_async(dispatch_get_main_queue()) { 
            self.presentViewController(updateProfileNC, animated: true, completion: nil)
        }
    }

    private func showSelectRoleVC() {
        if let role = UserDefaultsHelper().getRole() {

        } else {
            ProfileUpdateHelper(vc: self).switchRole()
        }
    }

    private func createClassroom() {
        self.selectedIndex = 1
        let classroomVC = self.classroomNC.viewControllers[0] as! ClassroomViewController
        classroomVC.willCreateClassroom = true
    }

}
