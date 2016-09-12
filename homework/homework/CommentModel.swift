//
//  CommentModel.swift
//  homework
//
//  Created by Liu, Naitian on 9/10/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class CommentModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var submissionUUID: String = ""
    dynamic var author: String = ""
    dynamic var info: NSData = NSData()
    dynamic var createdTimestamp: Int = 0

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class CommentModelHelper {

    let commentKeys = GlobalKeys.CommentKeys.self

    init() {

    }

    func add(commentUUID: String, submissionUUID: String, author: String, info: NSData, createdTimestamp: Int) {
        let comment = CommentModel()
        comment.uuid = commentUUID
        comment.submissionUUID = submissionUUID
        comment.author = author
        comment.info = info
        comment.createdTimestamp = createdTimestamp
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(comment, update: true)
            })
        } catch {
            print(error)
        }
    }

    func getList(submissionUUID: String) -> [[String: AnyObject]] {
        var commentArray: [[String: AnyObject]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(CommentModel).filter("submissionUUID = '\(submissionUUID)'") {
                let rowDict = self.getRowDictByItem(item)
                commentArray.append(rowDict)
            }
        } catch {
            print(error)
        }
        return commentArray
    }

    private func getRowDictByItem(item: CommentModel) -> [String: AnyObject] {
        let rowDict: [String: AnyObject] = [
            self.commentKeys.commentUUID: item.uuid,
            self.commentKeys.submissionUUID: item.submissionUUID,
            self.commentKeys.author: item.author,
            self.commentKeys.info: item.info,
            self.commentKeys.createdTimestamp: item.createdTimestamp
        ]
        return rowDict
    }

}
