//
//  DataTypeConversionHelper.swift
//  homework
//
//  Created by Liu, Naitian on 9/3/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation

class DataTypeConversionHelper {

    init() {

    }

    func convertDictToNSData(dict: [String: AnyObject]) -> NSData {
        let data = NSKeyedArchiver.archivedDataWithRootObject(dict)
        return data
    }

    func convertNSDataToDict(data: NSData) -> [String: AnyObject] {
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! [String: AnyObject]
        return dict
    }
}