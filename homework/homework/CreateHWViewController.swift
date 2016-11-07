//
//  CreateHWViewController.swift
//  homework
//
//  Created by Liu, Naitian on 8/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import MBProgressHUD

class CreateHWViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedClassroomUUID: String?
    var selectedClassroomName: String?
    var selectedDate: NSDate?
    var selectedType: String?
    var content: String?

    let homeworkKeys = GlobalKeys.HomeworkKeys.self
    let submissionKeys = GlobalKeys.SubmissionKeys.self

    var imageArray: [UIImage]!
    var imageURLs: [String] = []
    let imagePicker = UIImagePickerController()
    var audioArray: [[String: AnyObject]] = []

    var info: [String: AnyObject] = [:]

    var currentUploadIndex: Int = 0
    var hudHelper: ProgressHUDHelper!

    typealias CompletionClosureType = () -> Void
    var completionBlock: CompletionClosureType?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageArray = []

        if let classroomUUID = selectedClassroomUUID {
            self.selectedClassroomName = ClassroomModelHelper().getClassroomNameByUUID(classroomUUID)
        }

        if let type = selectedType {
            self.navigationItem.title = type
        }

        self.imagePicker.delegate = self

        self.hudHelper = ProgressHUDHelper(view: self.view)

        self.initTableView()
        self.reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }

    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .OnDrag
        tableView.registerNib(UINib(nibName: "EditTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "EditTextViewTableViewCell")
        tableView.registerNib(UINib(nibName: "AudioRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioRecordTableViewCell")
        tableView.registerNib(UINib(nibName: "ImagesCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesCollectionTableViewCell")
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func submitButtonOnClick(sender: AnyObject) {
        self.performCreateHomework()
    }

    func reloadTable() {
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return self.audioArray.count + 1
        case 3:
            return 1
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("EditTextViewTableViewCell") as! EditTextViewTableViewCell
            cell.configurate({ (text) in
                print(text)
                self.content = text
            })
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = self.setupRightDetailCell("班级", detail: self.selectedClassroomName, imageName: "icon-classroom-gray")
                return cell
            } else {
                var dateString: String? = nil
                if let date = self.selectedDate {
                    dateString = DateUtility().convertUTCDateToHumanFriendlyDateString(date)
                }
                let cell = self.setupRightDetailCell("截止时间", detail: dateString, imageName: "icon-clock-gray")
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordTableViewCell") as! AudioRecordTableViewCell
            if indexPath.row < self.audioArray.count {
                let rowDict = self.audioArray[indexPath.row]
                let audioDuration: NSTimeInterval = rowDict[self.submissionKeys.duration]! as! NSTimeInterval
                let recordName: String? = rowDict[self.submissionKeys.recordName] as? String
                cell.configurate(audioDuration, recordName: recordName)
            } else {
                cell.configurate(nil, recordName: nil)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("ImagesCollectionTableViewCell") as! ImagesCollectionTableViewCell
            cell.configurate(self.imageArray, addImageClicked: {
                self.showSelectAddImageTypeActionSheet()
                }, imagePicked: { (index) in
                    self.showPhotoBrowser(index)
                }, didDelete: { (imageArray) in
                    self.imageArray = imageArray
            })
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
        case (1, 0):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
            self.showClassroomPickerVC()
        case (1, 1):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.view.endEditing(true)
            self.showCalendarDatePickerVC()
        case (2, self.audioArray.count):
            self.view.endEditing(true)
            self.showAudioRecordVC()
        default:
            break
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return "录制的语音内容（可选）"
        case 3:
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
        audioHWRecordVC.audioUploadedCompletionBlockSetter { (duration, filename, audioURL, recordName) in
            let rowDict: [String: AnyObject] = [
                self.submissionKeys.duration: Int(duration),
                self.submissionKeys.audioURL: audioURL,
                self.submissionKeys.recordName: recordName
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
                        self.info[self.submissionKeys.imageURLList] = self.imageURLs
                        let classroomUUID = self.selectedClassroomUUID!
                        let dueDateTimestamp = self.info[self.homeworkKeys.dueDateTimestamp] as! Int
                        APIHomeworkCreate(vc: self).run(classroomUUID, dueDateTimestamp: dueDateTimestamp, info: self.info)
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

    private func setupRightDetailCell(title: String, detail: String?, imageName: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.accessoryType = .DisclosureIndicator
        cell.imageView?.image = UIImage(named: imageName)
        cell.textLabel?.text = title
        if let detail = detail {
            cell.detailTextLabel?.text = detail
        } else {
            cell.detailTextLabel?.text = "未选择"
        }
        return cell
    }

    private func showCalendarDatePickerVC() {
        let calendarDatePickerVC = CalendarDatePickerViewController(nibName: "CalendarDatePickerViewController", bundle: nil)
        calendarDatePickerVC.selectedDate = self.selectedDate
        calendarDatePickerVC.completeSelectionBlockSetter { (date) in
            self.selectedDate = date
        }
        self.navigationController?.pushViewController(calendarDatePickerVC, animated: true)
    }

    private func showClassroomPickerVC() {
        let classroomPickerVC = ClassroomPickerViewController(nibName: "ClassroomPickerViewController", bundle: nil)
        classroomPickerVC.completeSelectionBlockSetter { (classroomUUID, classroomName) in
            self.selectedClassroomUUID = classroomUUID
            self.selectedClassroomName = classroomName
        }
        self.navigationController?.pushViewController(classroomPickerVC, animated: true)
    }

    private func performCreateHomework() {
        guard let classroomUUID = self.selectedClassroomUUID else {
            AlertHelper(viewController: self).showPromptAlertView("请选择班级")
            return
        }
        guard let dueDate = self.selectedDate else {
            AlertHelper(viewController: self).showPromptAlertView("请选择截止日期")
            return
        }
        let type: String = self.selectedType!
        let dueDateTimestamp: Int = DateUtility().convertDateToEpoch(dueDate)
        self.info[self.homeworkKeys.type] = type
        self.info[self.homeworkKeys.content] = content!
        self.info[self.homeworkKeys.dueDateTimestamp] = dueDateTimestamp
        self.info[self.submissionKeys.audioList] = self.audioArray
        if self.imageArray.count > 0 {
            self.hudHelper.showWithTitle("正在上传图片")
            self.uploadImagesAndSubmit()
        } else {
            APIHomeworkCreate(vc: self).run(classroomUUID, dueDateTimestamp: dueDateTimestamp, info: self.info)
        }

    }
}
