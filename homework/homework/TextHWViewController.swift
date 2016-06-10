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
    var svContentView: UIView!
    var imageView: UIImageView!
    
    var markViewHelper: TextHWMarkViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.blackColor()
        
        scrollView = UIScrollView(frame: self.view.bounds)
        
        self.view.addSubview(scrollView)
        
        let image = UIImage(named: "hw_sample")
        self.initImageView(image)
        
        svContentView = UIView(frame: imageView.frame)
        scrollView.addSubview(svContentView)
        
        svContentView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = Constant.maximumZoomScale
        scrollView.minimumZoomScale = Constant.minimumZoomScale
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        // singleTap.requireGestureRecognizerToFail(doubleTap)
        scrollView.addGestureRecognizer(singleTap)
        
        self.markViewHelper = TextHWMarkViewHelper(svContentView: self.svContentView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initImageView(image: UIImage?) {
        let imageWidth:CGFloat = (image?.size.width)!
        let imageHeight:CGFloat = (image?.size.height)!
        self.imageView = UIImageView(image: image)
        self.imageView.contentMode = .ScaleAspectFit
        let imageViewWidth = self.view.frame.width
        let imageViewHeight = imageViewWidth * imageHeight / imageWidth
        print(imageViewHeight)
        print(self.view.frame.height)
        if imageViewHeight > self.view.frame.height {
            imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        } else {
            // let y = (self.view.frame.width - imageViewHeight) / 2
            imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: self.view.frame.height)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return svContentView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        self.markViewHelper.hideAll()
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        self.markViewHelper.hideAll()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.markViewHelper.hideAll()
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        let scale: CGFloat = self.scrollView.zoomScale
        let center: CGPoint = recognizer.locationInView(recognizer.view)
        let newCenter: CGPoint = CGPoint(x: center.x / scale, y: center.y / scale)
        self.markViewHelper.addMark(newCenter)
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
