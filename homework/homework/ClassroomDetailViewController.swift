//
//  ClassroomDetailViewController.swift
//  homework
//
//  Created by Liu, Naitian on 7/27/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

class ClassroomDetailViewController: UIViewController {

    @IBOutlet weak var homeworkCountLabel: UILabel!

    @IBOutlet weak var swipeView: ZLSwipeableView!

    @IBOutlet weak var homeworkActionView: UIView!

    var classroomUUID: String!

    let homeworkViewModel = HomeworkViewModel()

    let homeworkKeys = GlobalKeys.HomeworkKeys.self

    let role = UserDefaultsHelper().getRole()!
    
    var currentIndex = 0
    var currentShiftIndex = 0

    var numberOfLayoutCalls = 0

    var cardDataArray = [[String: AnyObject]]()

    var cardNumberOfActiveView: UInt = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardDataArray = self.homeworkViewModel.getCurrentHomeworksData(self.classroomUUID)

        self.countHomeworkNumber()

        numberOfLayoutCalls = 0

        swipeView.didTap = {view, location in
            // action when tap view
            self.showHomeworkDetailVC()
        }

        swipeView.didEnd = {view, location in
            // count
            self.countHomeworkNumber()
        }

        APIHomeworkGetHomeworkList(vc: self).run(self.classroomUUID)

        // self.reloadHomeworks()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatch_async(dispatch_get_main_queue()) {
            self.numberOfLayoutCalls += 1
            if self.numberOfLayoutCalls > 1 {
                self.swipeView.numberOfActiveView = self.cardNumberOfActiveView
                self.swipeView.nextView = {
                    return self.nextCardView()
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.role == "t" {
            self.renderHomeworkActionView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func resetNumberOfActiveViews() {
        let cardNumber = UInt(self.cardDataArray.count)
        let limit: UInt = 6
        if cardNumber >= limit {
            self.cardNumberOfActiveView = limit
        } else {
            self.cardNumberOfActiveView = cardNumber
        }
    }

    func reloadHomeworks() {
        dispatch_async(dispatch_get_main_queue()) {
            self.cardDataArray = self.homeworkViewModel.getCurrentHomeworksData(self.classroomUUID)
            self.resetNumberOfActiveViews()
            self.swipeView.discardViews()
            self.swipeView.numberOfActiveView = self.cardNumberOfActiveView
            self.currentShiftIndex = 0
            self.swipeView.loadViews()
            self.currentIndex = 0
            self.countHomeworkNumber()
        }
    }

    private func countHomeworkNumber() {
        if self.cardDataArray.count > 0 {
            homeworkCountLabel.text = "当前作业 (\(currentIndex+1)/\(self.cardDataArray.count))"
        } else {
            homeworkCountLabel.text = "当前作业: 暂无"
        }
    }

    func nextCardView() -> UIView? {
        if self.cardDataArray.count > 0 {
            let cardView = HomeworkCardView(frame: self.swipeView.bounds)

            let contentView = NSBundle.mainBundle().loadNibNamed("HomeworkCardContentView", owner: self, options: nil)!.first! as! HomewordCardContentView
            contentView.configurate(self.cardDataArray[currentShiftIndex])
            currentShiftIndex += 1
            currentIndex += 1
            contentView.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(contentView)

            self.constrain(cardView, view2: contentView)

            if currentShiftIndex >= cardDataArray.count {
                currentShiftIndex = 0
            }
            if currentIndex >= cardDataArray.count {
                currentIndex = 0
            }
            print(self.currentIndex)
            
            return cardView

        } else {
            return nil
        }
    }

    private func constrain(view1: UIView, view2: UIView) {
        let metrics = ["width":view1.bounds.width, "height": view1.bounds.height]
        let views = ["view2": view2, "view1": view1]
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view2(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view2(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
    }

    private func showHomeworkDetailVC() {
        let rowDict = self.cardDataArray[currentIndex]
        let homeworkUUID: String = rowDict[self.homeworkKeys.homeworkUUID]! as! String
        if self.role == "t" {
            let homeworkDetailVC = HomeworkDetailViewController(nibName: "HomeworkDetailViewController", bundle: nil)
            homeworkDetailVC.homeworkUUID = homeworkUUID
            homeworkDetailVC.didCloseHomeworkBlockSetter({ 
                self.reloadHomeworks()
            })
            self.navigationController?.pushViewController(homeworkDetailVC, animated: true)
        } else if self.role == "s" {
            let studentHWDetailVC = StudentHomeworkDetailViewController(nibName: "StudentHomeworkDetailViewController", bundle: nil)
            studentHWDetailVC.homeworkUUID = homeworkUUID
            self.navigationController?.pushViewController(studentHWDetailVC, animated: true)
        }
    }

    private func renderHomeworkActionView() {
        let viewWidth = self.homeworkActionView.frame.width
        let viewHeight = self.homeworkActionView.frame.height
        let btnWidth: CGFloat = 150
        let btnHeight: CGFloat = 30
        let x: CGFloat = (viewWidth - btnWidth) / 2
        let y: CGFloat = (viewHeight - btnHeight) / 2
        let btnFrame = CGRect(x: x, y: y, width: btnWidth, height: btnHeight)
        let button = UIButton(type: .System)
        button.frame = btnFrame
        button.setTitle("发布新的作业", forState: .Normal)
        button.setTitleColor(GlobalConstants.themeColor, forState: .Normal)
        button.layer.borderColor = GlobalConstants.themeColor.CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.newHomeworkButtonOnClick), forControlEvents: .TouchUpInside)
        self.homeworkActionView.addSubview(button)
    }

    func newHomeworkButtonOnClick(sender: AnyObject!) {
        PresentVCUtility(vc: self).showSelectHWTypeVC(self.classroomUUID, completion: {
            self.reloadHomeworks()
        })
    }

    @IBAction func moreInfoButtonOnClick(sender: AnyObject) {
        let classroomInfoVC = ClassroomInfoViewController(nibName: "ClassroomInfoViewController", bundle: nil)
        classroomInfoVC.classroomUUID = classroomUUID
        self.navigationController?.pushViewController(classroomInfoVC, animated: true)
    }

    @IBAction func homeworkButtonOnClick(sender: AnyObject) {
        /*
        let homeworkListVC = HomeworkListViewController(nibName: "HomeworkListViewController", bundle: nil)
        homeworkListVC.classroomUUID = classroomUUID
        self.navigationController?.pushViewController(homeworkListVC, animated: true)
        */
        let calendarHWVC = CalendarHWViewController(nibName: "CalendarHWViewController", bundle: nil)
        calendarHWVC.classroomUUID = classroomUUID
        self.navigationController?.pushViewController(calendarHWVC, animated: true)
    }

    @IBAction func teacherButtonOnClick(sender: AnyObject) {
        self.showMemberListVC("t")
    }

    @IBAction func studentButtonOnClick(sender: AnyObject) {
        self.showMemberListVC("s")
    }

    @IBAction func notificationButtonOnClick(sender: AnyObject) {
        let notificationListVC = NotificationListViewController(nibName: "NotificationListViewController", bundle: nil)
        self.navigationController?.pushViewController(notificationListVC, animated: true)
    }

    private func showMemberListVC(type: String) {
        let memberListVC = MemberListViewController(nibName: "MemberListViewController", bundle: nil)
        memberListVC.classroomUUID = classroomUUID
        memberListVC.type = type
        self.navigationController?.pushViewController(memberListVC, animated: true)
    }
    

}

