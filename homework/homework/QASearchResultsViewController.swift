//
//  QASearchResultsViewController.swift
//  homework
//
//  Created by Liu, Naitian on 9/17/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class QASearchResultsViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {

    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(1)
    }

}
