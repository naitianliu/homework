//
//  GlobalKeys.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation


struct GlobalKeys {

    struct HomeworkKeys {
        static let homeworkUUID = "homework_uuid"
        static let classroomUUID = "classroom_uuid"
        static let creator = "creator"
        static let active = "active"
        static let createdTimestamp = "created_timestamp"
        static let updatedTimestamp = "updated_timestamp"
        static let info = "info"
        static let type = "type"
        static let content = "content"
        static let dueDateTimestamp = "due_date_timestamp"

        static let teacherImgURL = "teacher_img_url"
        static let teacherName = "teacher_name"
        static let createdTimeString = "created_time_string"
        static let dueDateString = "due_date_string"
    }

    struct HomeworkTypeKeys {
        static let normal = "普通作业"
        static let reading = "朗读作业"
        static let recitation = "背诵作业"
        static let dictation = "听写作业"
    }

    struct ProfileKeys {
        static let imgURL = "img_url"
        static let userId = "user_id"
        static let nickname = "nickname"
    }
}