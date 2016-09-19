//
//  QASearchViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class QASearchViewController: UIViewController {

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        self.searchController.searchBar.becomeFirstResponder()
    }

    private func initSearchController() {
        let searchResultsController = QASearchResultsViewController(nibName: "QASearchResultsViewController", bundle: nil)
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController.searchResultsUpdater = searchResultsController
        self.searchController.searchBar.delegate = searchResultsController
        self.searchController.searchBar.frame = CGRect(x: self.searchController.searchBar.frame.origin.x, y: self.searchController.searchBar.frame.origin.y, width: self.searchController.searchBar.frame.size.width, height: 44.0)
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.navigationItem.titleView = self.searchController.searchBar
    }

    

}
