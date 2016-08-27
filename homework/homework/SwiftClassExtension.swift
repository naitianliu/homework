//
//  SwiftClassExtension.swift
//  homework
//
//  Created by Liu, Naitian on 8/25/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

extension RangeReplaceableCollectionType where Generator.Element : Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}