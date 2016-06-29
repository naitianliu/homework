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
    let findStoryboard = UIStoryboard(name: "Find", bundle: nil)
    let meStoryboard = UIStoryboard(name: "Me", bundle: nil)
    
    var homeNC: UINavigationController!
    var classroomNC: UINavigationController!
    var findNC: UINavigationController!
    var meNC: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.tintColor = GlobalConstants.themeColor
        
        homeNC = homeStoryboard.instantiateViewControllerWithIdentifier("HomeNC") as! UINavigationController
        homeNC.tabBarItem.title = "首页"
        homeNC.tabBarItem.image = UIImage(named: "tab-home")
        
        classroomNC = classroomStoryboard.instantiateViewControllerWithIdentifier("ClassroomNC") as! UINavigationController
        classroomNC.tabBarItem.title = "班级"
        classroomNC.tabBarItem.image = UIImage(named: "tab-classroom")
        
        findNC = findStoryboard.instantiateViewControllerWithIdentifier("FindNC") as! UINavigationController
        findNC.tabBarItem.title = "查找"
        findNC.tabBarItem.image = UIImage(named: "tab-find")
        
        meNC = meStoryboard.instantiateViewControllerWithIdentifier("MeNC") as! UINavigationController
        meNC.tabBarItem.title = "我"
        meNC.tabBarItem.image = UIImage(named: "tab-me")
        
        self.viewControllers = [homeNC, classroomNC, findNC, meNC]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
