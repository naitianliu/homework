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

    let sampleData = ["test1", "test2", "test3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        homeworkCountLabel.text = "当前作业"

        numberOfLayoutCalls = 0
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numberOfLayoutCalls += 1
        if numberOfLayoutCalls > 1 {
            swipeView.numberOfActiveView = UInt(sampleData.count)
            swipeView.nextView = {
                return self.nextCardView()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func nextCardView() -> UIView? {
        if currentIndex >= sampleData.count {
            currentIndex = 0
        }

        let cardView = HomeworkCardView(frame: self.swipeView.bounds)

        let contentView = NSBundle.mainBundle().loadNibNamed("HomeworkCardContentView", owner: self, options: nil).first! as! HomewordCardContentView
        contentView.configurate(sampleData[currentIndex])
        currentIndex += 1
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentView)

        self.constrain(cardView, view2: contentView)

        return cardView

    }

    private func constrain(view1: UIView, view2: UIView) {
        let metrics = ["width":view1.bounds.width, "height": view1.bounds.height]
        let views = ["view2": view2, "view1": view1]
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view2(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
        view1.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view2(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
    }

}
