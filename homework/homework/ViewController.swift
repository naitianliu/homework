//
//  ViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let homeworkStoryboard = UIStoryboard(name: "Homework", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TextHWViewControllerOnClick(sender: AnyObject) {
        
        let textHWVC = self.homeworkStoryboard.instantiateViewControllerWithIdentifier("TextHWViewController") as! TextHWViewController
        textHWVC.modalTransitionStyle = .CoverVertical
        self.presentViewController(textHWVC, animated: true, completion: nil)
        
    }
}

