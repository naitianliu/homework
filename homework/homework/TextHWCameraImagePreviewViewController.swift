//
//  TextHWCameraImagePreviewViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/10/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TextHWCameraImagePreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let image = image {
            self.imageView.image = image
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeButtonOnClick(sender: AnyObject) {
        
    }

    @IBAction func retakeButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(false) { 
            
        }
    }
    
    @IBAction func takeNextPageButtonOnClick(sender: AnyObject) {
        
    }
}
