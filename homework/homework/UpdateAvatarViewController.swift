//
//  UpdateAvatarViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/4/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SDWebImage
import RSKImageCropper

class UpdateAvatarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {

    let apiURL = APIURL.authUserProfileUpdate

    @IBOutlet weak var avatarImageView: UIImageView!

    let placeholderImage = UIImage(named: "profile-placeholder")

    let imagePicker = UIImagePickerController()

    var newImage: UIImage?

    var progressHUD: ProgressHUDHelper!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self

        if let imgURL = UserDefaultsHelper().getProfileImageURL() {
            avatarImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }

        progressHUD = ProgressHUDHelper(view: self.view)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        renderAvatarImageView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateAvatarButtonOnClick(sender: AnyObject) {
        let alertController = UIAlertController(title: "更换头像", message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "拍照", style: .Default, handler: { (action) in
            // take picture
            self.takePicture()
        }))
        alertController.addAction(UIAlertAction(title: "从手机相册选择", style: .Default, handler: { (action) in
            // pick image
            self.pickImage()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func renderAvatarImageView() {
        let width = avatarImageView.frame.width
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = GlobalConstants.themeColor.CGColor
        avatarImageView.layer.cornerRadius = width / 2
        avatarImageView.layer.masksToBounds = true
    }

    private func takePicture() {

    }

    private func pickImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        newImage = image
        self.dismissViewControllerAnimated(true) {
            self.showImageCropVC()
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func showImageCropVC() {
        if let newImage = newImage {
            let imageCropVC = RSKImageCropViewController(image: newImage)
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }

    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.avatarImageView.image = croppedImage
        self.navigationController?.popViewControllerWithCompletion(true, complete: { 
            let compressedImage = ImageHelper().resizeAvatarImage(croppedImage)
            self.uploadImage(compressedImage)
        })
    }

    private func uploadImage(image: UIImage) {
        let objectKey = NSUUID().UUIDString
        let filepath = FileHelper().saveImageToFile(image, objectKey: objectKey)
        if let filepath = filepath {
            self.progressHUD.show()
            OSSHelper().uploadFile(filepath, objectKey: objectKey, complete: { (success, objectURL) in
                if success {
                    print(objectURL)
                    self.updateProfileImageURL(objectURL!)
                } else {
                    self.progressHUD.hide()
                }
            })
        }
    }

    private func updateProfileImageURL(imageURL: String) {
        CallAPIHelper(url: self.apiURL, data: ["img_url": imageURL]).POST({ (responseData) in
            // completion
            self.progressHUD.hide()
            UserDefaultsHelper().updateProfileImageURL(imageURL)
            }) { (error) in
                // error
                self.progressHUD.hide()
        }
    }
}
