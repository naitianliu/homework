//
//  HomeViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/29/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import Popover

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var popover: Popover!
    @IBOutlet weak var addButton: UIBarButtonItem!

    typealias CreateClassroomClosureType = () -> Void
    var createClassroomBlock: CreateClassroomClosureType?

    let popoverTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 140, height: 131))
    let popoverMenuData = [
        ["image": "icon-classroom", "title": "创建班级"],
        ["image": "icon-homework", "title": "发布作业"],
        ["image": "icon-qrcode", "title": "扫二维码"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupPopoverView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonOnClick(sender: AnyObject) {
        let popoverOptions: [PopoverOption] = [
            .Type(.Down),
            .CornerRadius(0),
            .SideEdge(0)
        ]
        let startPoint = CGPoint(x: self.view.frame.width - 25, y: 55)
        self.popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(popoverTableView, point: startPoint)
    }


    private func setupPopoverView() {
        popoverTableView.delegate = self
        popoverTableView.dataSource = self
        popoverTableView.scrollEnabled = false
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popoverTableView {
            return 3
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == popoverTableView {
            let rowData = popoverMenuData[indexPath.row]
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = rowData["title"]
            cell.textLabel?.textColor = GlobalConstants.themeColor
            cell.imageView?.image = UIImage(named: rowData["image"]!)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == popoverTableView {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            self.popover.dismiss()
            if indexPath.row == 0 {
                self.createClassroomBlock!()
            } else if indexPath.row == 1 {
                PresentVCUtility(vc: self).showSelectHWTypeVC()
            } else if indexPath.row == 2 {

            }
        }
    }


}
