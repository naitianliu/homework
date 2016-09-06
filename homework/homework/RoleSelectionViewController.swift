//
//  RoleSelectionViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/28/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class RoleSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = GlobalConstants.themeColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectTeacherButtonOnClick(sender: AnyObject) {
        UserDefaultsHelper().updateRole("t")
        self.reloadApplication()
    }

    @IBAction func selectStudentButtonOnClick(sender: AnyObject) {
        UserDefaultsHelper().updateRole("s")
        self.reloadApplication()
    }

    @IBAction func learnMoreButtonOnClick(sender: AnyObject) {

    }

    func reloadApplication() {
        PerformMigrations().setDefaultRealmForUser()
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
