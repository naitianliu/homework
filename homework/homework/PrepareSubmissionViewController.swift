//
//  PrepareSubmissionViewController.swift
//  homework
//
//  Created by Liu, Naitian on 10/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import MBProgressHUD

class PrepareSubmissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var homeworkUUID: String!
    var homeworkData: [String: AnyObject]!

    let homeworkViewModel = HomeworkViewModel()

    var imageArray: [UIImage] = []

    var imageURLs: [String] = []

    let imagePicker = UIImagePickerController()

    var audioArray: [[String: AnyObject]] = []

    let submissionKeys = GlobalKeys.SubmissionKeys.self

    var currentUploadIndex: Int = 0

    typealias CompletePrepareSubmissionClosureType = (info: [String: AnyObject]) -> Void
    var completePrepareSubmissionBlock: CompletePrepareSubmissionClosureType?

    var hudHelper: ProgressHUDHelper!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "准备提交内容"
        self.initiateSubmitButton()
        self.initiateCancelButton()
        self.initTableView()

        self.imagePicker.delegate = self

        self.hudHelper = ProgressHUDHelper(view: self.view)

        self.reloadTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func completePrepareSubmissionBlockSetter(completePrepareSubmission: CompletePrepareSubmissionClosureType) {
        self.completePrepareSubmissionBlock = completePrepareSubmission
    }

    func reloadTable() {
        homeworkData = self.homeworkViewModel.getHomeworkInfo(self.homeworkUUID)
        tableView.reloadData()
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "HomeworkInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeworkInfoTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.registerNib(UINib(nibName: "ImagesCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesCollectionTableViewCell")
    }

    private func initiateSubmitButton() {
        let submitButton = UIBarButtonItem(title: "确认提交", style: .Plain, target: self, action: #selector(self.submitButtonOnClick))
        self.navigationItem.rightBarButtonItem = submitButton
    }

    private func initiateCancelButton() {
        let cancelButton = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(self.cancelButtonOnClick))
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    @objc private func submitButtonOnClick(sender: AnyObject) {
        if self.imageArray.count == 0 && self.audioArray.count == 0 {
            AlertHelper(viewController: self).showPromptAlertView("语音和图片至少有一个不能为空")
            return
        }
        if self.imageArray.count > 0 {
            self.hudHelper.showWithTitle("正在上传图片")
            self.uploadImagesAndSubmit()
        } else {
            let info: [String: AnyObject] = [
                self.submissionKeys.audioList: self.audioArray
            ]
            self.dismissViewControllerAnimated(true, completion: {
                self.completePrepareSubmissionBlock!(info: info)
            })
        }
    }

    @objc private func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.audioArray.count + 1
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeworkInfoTableViewCell") as! HomeworkInfoTableViewCell
            cell.configurate(homeworkData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
            if indexPath.row < self.audioArray.count {
                let rowDict = self.audioArray[indexPath.row]
                let audioDuration: NSTimeInterval = rowDict[self.submissionKeys.duration]! as! NSTimeInterval
                cell.configurate(audioDuration)
            } else {
                cell.configurate(nil)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("ImagesCollectionTableViewCell") as! ImagesCollectionTableViewCell
            cell.configurate(self.imageArray, addImageClicked: {
                self.showSelectAddImageTypeActionSheet()
                }, imagePicked: { (index) in
                    self.showPhotoBrowser(index)
            })
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == self.audioArray.count {
            self.showAudioRecordVC()
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 20
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "录制的语音内容（可选）"
        case 2:
            return "准备的图片内容（可选）"
        default:
            return nil
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageArray.append(image)
        self.dismissViewControllerAnimated(true) { 
            self.reloadTable()
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func showSelectAddImageTypeActionSheet() {
        let alertController = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "拍照", style: .Default, handler: { (action) in
            self.showImagePickerController("camera")
        }))
        alertController.addAction(UIAlertAction(title: "从手机相册选择", style: .Default, handler: { (action) in
            self.showImagePickerController("photo")
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func showImagePickerController(type: String) {
        imagePicker.allowsEditing = false
        if type == "camera" {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    private func showPhotoBrowser(index: Int) {
        var photos = [SKPhoto]()
        for image in self.imageArray {
            let photo = SKPhoto.photoWithImage(image)
            photos.append(photo)
        }
        // initiate browser
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(index)
        presentViewController(browser, animated: true, completion: nil)
    }

    private func showAudioRecordVC() {
        let audioHWRecordVC = AudioHWRecordViewController(nibName: "AudioHWRecordViewController", bundle: nil)
        audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL) in
            let rowDict: [String: AnyObject] = [
                self.submissionKeys.duration: Int(duration),
                self.submissionKeys.audioURL: audioURL
            ]
            self.audioArray.append(rowDict)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(audioHWRecordVC, animated: true)
    }

    private func uploadImagesAndSubmit() {
        self.hudHelper.updateSubtitle("已完成 \(self.currentUploadIndex)/\(self.imageArray.count)")
        let image = self.imageArray[self.currentUploadIndex]
        let objectKey = NSUUID().UUIDString
        let filepath = FileHelper().saveCompressedJPEGImageToFile(image, objectKey: objectKey)
        if let filepath = filepath {
            OSSHelper().uploadFile(filepath, objectKey: objectKey, complete: { (success, objectURL) in
                if success {
                    print(objectURL)
                    self.imageURLs.append(objectURL!)
                    if self.currentUploadIndex == self.imageArray.count - 1 {
                        // complete all and call submit api
                        ProgressHUDHelper(view: self.view).hide()
                        self.currentUploadIndex = 0
                        let info: [String: AnyObject] = [
                            self.submissionKeys.audioList: self.audioArray,
                            self.submissionKeys.imageURLList: self.imageURLs
                        ]
                        self.dismissViewControllerAnimated(true, completion: { 
                            self.completePrepareSubmissionBlock!(info: info)
                        })
                    } else {
                        self.currentUploadIndex += 1
                        self.uploadImagesAndSubmit()
                    }
                } else {
                    ProgressHUDHelper(view: self.view).hide()
                    AlertHelper(viewController: self).showPromptAlertView("图片上传失败，请检查网络连接，并稍后重试。")
                }
                }, uploadProgress: {(progress) in
                    print(progress)
            })
        }
    }

}
