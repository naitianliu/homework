//
//  TextHWViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TextHWViewController: UIViewController, UIScrollViewDelegate {
    struct Constant {
        static let maximumZoomScale: CGFloat = 2.0
        static let minimumZoomScale: CGFloat = 1.0
    }

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.blackColor()
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        let image = UIImage(named: "hw_sample2")
        let imageWidth:CGFloat = (image?.size.width)!
        let imageHeight:CGFloat = (image?.size.height)!
        self.imageView = UIImageView(image: image)
        let imageViewWidth = self.view.frame.width
        let imageViewHeight = imageViewWidth * imageHeight / imageWidth
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = Constant.maximumZoomScale
        scrollView.minimumZoomScale = Constant.minimumZoomScale
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            // self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
            let zoomRect:CGRect = self.zoomRectForScale(self.scrollView.maximumZoomScale, center: recognizer.locationInView(recognizer.view))
            self.scrollView.zoomToRect(zoomRect, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let height = self.scrollView.frame.height / scale
        let width = self.scrollView.frame.width / scale
        let x = center.x - width / 2
        let y = center.y - height / 2
        let zoomRect = CGRect(x: x, y: y, width: width, height: height)
        return zoomRect
    }

}
