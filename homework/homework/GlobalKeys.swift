//
//  GlobalKeys.swift
//  homework
//
//  Created by Liu, Naitian on 9/1/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation


struct GlobalKeys {

    struct ClassroomKeys {
        static let classroomUUID = "classroom_uuid"
        static let classroomName = "classroom_name"
        static let schoolName = "school_name"
        static let schoolUUID = "school_uuid"
        static let profileImgURLs = "profile_img_urls"
        static let studentNumber = "student_number"
        static let code = "code"
        static let introduction = "introduction"
        static let active = "active"
        static let creator = "creator"
    }

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

    struct UpdateKeys {
        static let updates = "updates"

        static let uuid = "uuid"
        static let timestamp = "timestamp"
        static let type = "type"
        static let info = "info"
        static let read = "read"

        static let homeworks = "homeworks"
        static let requests = "requests"
        static let submissions = "submissions"
        static let classrooms = "classrooms"
        static let members = "members"

        static let requestUUID = "request_uuid"
        static let requesterProfile = "requester_profile"

        static let imgURL = "img_url"
        static let timeString = "time_string"
        static let title = "title"
        static let subtitle = "subtitle"
        static let nickname = "nickname"


    }
}