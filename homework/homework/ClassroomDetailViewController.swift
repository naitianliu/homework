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

    var currentIndex = 0

    var numberOfLayoutCalls = 0

    let sampleData: [String: AnyObject] = [
        "profileImgURL": "https://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi.jpeg",
        "teacher": "Ali",
        "homeworkType": "朗读作业",
        "time": "昨天 12:55pm",
        "homeworkContent": "英语教材新概念英语第一册Lession 1阅读文章读三遍",
        "dueDate": "6月1日 星期三"
    ]

    var cardDataArray = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardDataArray.append(sampleData)
        self.cardDataArray.append(sampleData)

        self.countHomeworkNumber()

        numberOfLayoutCalls = 0

        swipeView.didTap = {view, location in
            // action when tap view
        }

        swipeView.didEnd = {view, location in
            // count
            self.countHomeworkNumber()
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numberOfLayoutCalls += 1
        if numberOfLayoutCalls > 1 {
            swipeView.numberOfActiveView = UInt(self.cardDataArray.count)
            swipeView.nextView = {
                return self.nextCardView()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func countHomeworkNumber() {
        homeworkCountLabel.text = "当前作业 (\(currentIndex+1)/\(self.cardDataArray.count))"
    }

    func nextCardView() -> UIView? {

        let cardView = HomeworkCardView(frame: self.swipeView.bounds)

        let contentView = NSBundle.mainBundle().loadNibNamed("HomeworkCardContentView", owner: self, options: nil).first! as! HomewordCardContentView
        contentView.configurate(self.cardDataArray[currentIndex])
        currentIndex += 1
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentView)

        self.constrain(cardView, view2: contentView)

        if currentIndex >= cardDataArray.count {
            currentIndex = 0
        }

        return cardView

    }

    private func constrain(view1: UIView, view2: UIView) {
        let metrics = ["width":view1.bounds.width, "height": view1.bounds.height]
        let views = ["view2": view2, "view1": view1]
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view2(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view2(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
    }

}
