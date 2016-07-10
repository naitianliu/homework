//
//  SelectSchoolViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/9/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class SelectSchoolViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var data = [String: String?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonOnClick(sender: AnyObject) {
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SchoolTableViewCell") as! SchoolTableViewCell
        let name = data["name"]!!
        let location = data["location"]!
        cell.configurate(name, location: location)
        return cell
    }

}
