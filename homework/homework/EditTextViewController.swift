//
//  EditTextViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SZTextView

class EditTextViewController: UIViewController {

    var navbarTitle: String?
    var placeholder: String?
    @IBOutlet weak var contentTextView: SZTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navbarTitle = navbarTitle {
            self.navigationItem.title = navbarTitle
        } else {
            self.navigationItem.title = "编辑"
        }

        if let placeholder = placeholder {
            contentTextView.placeholder = placeholder
        } else {
            contentTextView.placeholder = "编辑内容"
        }

        self.initiateConfirmButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initiateConfirmButton() {
        let confirmButton = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(self.confirmButtonOnClick))
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    func confirmButtonOnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
