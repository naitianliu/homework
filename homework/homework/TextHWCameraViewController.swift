//
//  TextHWCameraViewController.swift
//  homework
//
//  Created by Liu, Naitian on 6/7/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class TextHWCameraViewController: UIViewController {
    struct Constant {
        static let backButtonTitle = "取消"
        static let navItemTitle = "正在拍照"
        static let titleViewWidth: CGFloat = 200
        static let titleViewHeight: CGFloat = 44
        static let titleViewPadding: CGFloat = 10
    }
    
    var currentPage: Int = 1
    var totalPage: Int = 1
    
    var originalTopItemTitle: String?
    var originalTintColor: UIColor?
    var originalBarTintColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initNavTitleView()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
