//
//  QAViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/16/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import PageMenu

class QAViewController: UIViewController {

    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let qaNewVC = QANewViewController(nibName: "QANewViewController", bundle: nil)
        qaNewVC.title = "最新"
        qaNewVC.parentVC = self
        qaNewVC.filterType = "new"
        let qaPopularVC = QANewViewController(nibName: "QANewViewController", bundle: nil)
        qaPopularVC.title = "热门"
        qaPopularVC.parentVC = self
        qaPopularVC.filterType = "popular"
        let qaFavoriteVC = QANewViewController(nibName: "QANewViewController", bundle: nil)
        qaFavoriteVC.title = "我的提问"
        qaFavoriteVC.parentVC = self
        qaFavoriteVC.filterType = "me"
        let controllerArray: [UIViewController] = [qaNewVC, qaPopularVC, qaFavoriteVC]
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(GlobalConstants.themeColor),
            .AddBottomMenuHairline(false),
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .MenuHeight(50.0),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .SelectedMenuItemLabelColor(GlobalConstants.themeColor),
            .UnselectedMenuItemLabelColor(UIColor.lightGrayColor())
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    @IBAction func searchButtonOnClick(sender: AnyObject) {
        let qaSearchVC = QASearchViewController(nibName: "QASearchViewController", bundle: nil)
        self.navigationController?.pushViewController(qaSearchVC, animated: true)
    }

    @IBAction func askQuestionButtonOnClick(sender: AnyObject) {
        let qaQuestionCreateVC = QAQuestionCreateViewController(nibName: "QAQuestionCreateViewController", bundle: nil)
        self.navigationController?.pushViewController(qaQuestionCreateVC, animated: true)
    }



}
