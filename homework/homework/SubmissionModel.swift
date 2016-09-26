//
//  Submission.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import RealmSwift

class SubmissionModel: Object {
    
    dynamic var uuid: String = ""
    dynamic var homeworkUUID: String = ""
    dynamic var submitter: String = ""
    dynamic var score: String? = nil
    dynamic var createdTimestamp: Int = 0
    dynamic var updatedTimestamp: Int = 0

    dynamic var info: NSData = NSData()

    override static func primaryKey() -> String {
        return "uuid"
    }

}

class SubmissionModelHelper {

    let Keys = GlobalKeys.SubmissionKeys.self

    init() {

    }

    func add(submissionUUID: String, homeworkUUID: String, submitter: String, score: String?, createdTimestamp: Int?, updatedTimestamp: Int, info: NSData) {
        let submission = SubmissionModel()
        submission.uuid = submissionUUID
        submission.homeworkUUID = homeworkUUID
        submission.submitter = submitter
        if let score = score {
            submission.score = score
        }
        if let createdTimestamp = createdTimestamp {
            submission.createdTimestamp = createdTimestamp
        }
        submission.updatedTimestamp = updatedTimestamp
        submission.info = info
        do {
            let realm = try Realm()
            try realm.write({ 
                realm.add(submission, update: true)
            })
        } catch {
            print(error)
        }
    }

    func updateScore(submissionUUID: String, score: String) {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(SubmissionModel.self, key: submissionUUID) {
                try realm.write({ 
                    item.setValue(score, forKey: "score")
                })
            }
        } catch {
            print(error)
        }
    }

    func getListByHomework(homeworkUUID: String) -> [[String: AnyObject?]] {
        var submissionArray: [[String: AnyObject?]] = []
        do {
            let realm = try Realm()
            for item in realm.objects(SubmissionModel).filter("homeworkUUID = '\(homeworkUUID)'") {
                let rowDict = self.getRowDictByItem(item)
                submissionArray.append(rowDict)
            }
        } catch {
            print(error)
        }
        return submissionArray
    }

    func getSubmissionInfoByUUID(submissionUUID: String) -> [String: AnyObject?]? {
        do {
            let realm = try Realm()
            if let item = realm.objectForPrimaryKey(SubmissionModel.self, key: submissionUUID) {
                let rowDict = self.getRowDictByItem(item)
                return rowDict
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }

    private func getRowDictByItem(item: SubmissionModel) -> [String: AnyObject?] {
        let rowDict: [String: AnyObject?] = [
            Keys.submissionUUID: item.uuid,
            Keys.homeworkUUID: item.homeworkUUID,
            Keys.submitter: item.submitter,
            Keys.score: item.score,
            Keys.createdTimestamp: item.createdTimestamp,
            Keys.updatedTimestamp: item.updatedTimestamp,
            Keys.info: item.info
        ]
        return rowDict
    }
}
