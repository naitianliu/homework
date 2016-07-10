//
//  ClassroomViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ClassroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var data = [String: AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionButtonOnClick(sender: AnyObject) {
        self.showSetNameVC()
    }

    private func showSetNameVC() {
        let setNameVC = self.storyboard?.instantiateViewControllerWithIdentifier("SetClassroomNameViewController") as! SetClassroomNameViewController
        setNameVC.completeDismissBlock = {(name: String) in
            self.showCreateClassroomNC(name)
        }
        setNameVC.modalTransitionStyle = .CoverVertical
        self.presentViewController(setNameVC, animated: true, completion: nil)
    }

    private func showCreateClassroomNC(name: String) {
        let createClassroomNC = self.storyboard?.instantiateViewControllerWithIdentifier("CreateClassroomNC") as! UINavigationController
        let createClassroomVC = createClassroomNC.viewControllers[0] as! CreateClassroomViewController
        createClassroomVC.classroomName = name
        createClassroomNC.modalTransitionStyle = .CrossDissolve
        self.presentViewController(createClassroomNC, animated: false, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }


}
