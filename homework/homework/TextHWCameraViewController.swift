//
//  TextHWCameraViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/7/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import AVFoundation

class TextHWCameraViewController: UIViewController {
    struct Constant {
        static let backButtonTitle = "取消"
        static let navItemTitle = "正在拍照"
        static let titleViewWidth: CGFloat = 200
        static let titleViewHeight: CGFloat = 44
        static let titleViewPadding: CGFloat = 10
    }
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var stillImageOutput = AVCaptureStillImageOutput()
    
    var currentPage: Int = 1
    var totalPage: Int = 1
    
    var originalTopItemTitle: String?
    var originalTintColor: UIColor?
    var originalBarTintColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initNavTitleView()
        self.initCameraSettings()
        
    }
    
    func initCameraSettings() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if backCamera.position == AVCaptureDevicePosition.Back {
            captureDevice = backCamera
        }
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession?.addOutput(stillImageOutput)
        if captureDevice != nil {
            beiginSession()
        }
    }
    
    func beiginSession() {
        configureDevice()
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession!.canAddInput(input) {
                captureSession?.addInput(input)
            }
        } catch {
            print(error)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 100)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        print(previewLayer?.frame)
        self.cameraView.layer.addSublayer(previewLayer!)
        captureSession!.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            try! device.lockForConfiguration()
            device.focusMode = .Locked
            device.setFocusModeLockedWithLensPosition(0.5, completionHandler: { (time) in
                
            })
            device.unlockForConfiguration()
        }
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.originalTopItemTitle = self.navigationController?.navigationBar.topItem?.title
        self.originalTintColor = self.navigationController?.navigationBar.tintColor
        self.originalBarTintColor = self.navigationController?.navigationBar.barTintColor
        self.navigationController?.navigationBar.topItem?.title = Constant.backButtonTitle
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = self.originalTopItemTitle
        self.navigationController?.navigationBar.tintColor = self.originalTintColor
        self.navigationController?.navigationBar.barTintColor = self.originalBarTintColor
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initNavTitleView() {
        let width = Constant.titleViewWidth
        let height = Constant.titleViewHeight
        let padding = Constant.titleViewPadding
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let navTitleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: padding, width: width, height: (height - padding) / 2))
        navTitleLabel.textColor = UIColor.whiteColor()
        navTitleLabel.text = Constant.navItemTitle
        navTitleLabel.textAlignment = .Center
        navTitleLabel.font = UIFont.boldSystemFontOfSize(17)
        let navSubtitleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: (height + padding) / 2, width: width, height: (height - padding) / 2))
        navSubtitleLabel.textColor = UIColor.whiteColor()
        navSubtitleLabel.text = "第\(currentPage)页"
        navSubtitleLabel.textAlignment = .Center
        navSubtitleLabel.font = UIFont.systemFontOfSize(14)
        titleView.addSubview(navTitleLabel)
        titleView.addSubview(navSubtitleLabel)
        self.navigationItem.titleView = titleView
    }

    @IBAction func cameraButtonOnClick(sender: AnyObject) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProviderCreateWithCFData(imageData)
                let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
                self.showPreviewVC(image)
            })
        }
    }
    
    func showPreviewVC(image: UIImage) {
        let previewVC = self.storyboard?.instantiateViewControllerWithIdentifier("TextHWCameraImagePreviewViewController") as! TextHWCameraImagePreviewViewController
        previewVC.image = image
        self.presentViewController(previewVC, animated: false) { 
            
        }
    }

}
