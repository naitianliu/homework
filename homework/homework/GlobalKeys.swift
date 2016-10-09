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
        static let schoolInfo = "school_info"
        static let schoolName = "school_name"
        static let schoolAddress = "address"
        static let schoolUUID = "school_uuid"
        static let profileImgURLs = "profile_img_urls"
        static let studentNumber = "student_number"
        static let teacherNumber = "teacher_number"
        static let teachers = "teachers"
        static let students = "students"
        static let teacherProfiles = "teacher_profiles"
        static let members = "members"
        static let code = "code"
        static let introduction = "introduction"
        static let active = "active"
        static let creator = "creator"
        static let timestamp = "timestamp"
        static let createdTimestamp = "created_timestamp"
        static let updatedTimestamp = "updated_timestamp"
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

    struct SubmissionKeys {
        static let submissionUUID = "submission_uuid"
        static let homeworkUUID = "homework_uuid"
        static let submitter = "submitter"
        static let score = "score"
        static let createdTimestamp = "created_timestamp"
        static let updatedTimestamp = "updated_timestamp"
        static let info = "info"

        static let timestamp = "timestamp"

        static let duration = "duration"
        static let audioList = "audio_list"
        static let audioURL = "audio_url"

        static let submitterName = "submitter_name"
        static let submitterImgURL = "submitter_img_url"
        static let time = "time"
        static let submissionType = "submission_type"

        struct AudioStatus {
            static let pending = "pending"
            static let working = "working"
            static let complete = "complete"
            static let hidden = "hidden"

        }

    }

    struct CommentKeys {
        static let commentUUID = "comment_uuid"
        static let submissionUUID = "submission_uuid"
        static let author = "author"
        static let info = "info"
        static let createdTimestamp = "created_timestamp"

        static let text = "text"
        static let audioInfo = "audio_info"
        static let duration = "duration"
        static let audioURL = "audio_url"

        static let authorName = "author_name"
        static let authorImgURL = "author_img_url"
        static let time = "time"
        static let hasAudio = "has_audio"

    }

    struct ProfileKeys {
        static let imgURL = "img_url"
        static let userId = "user_id"
        static let nickname = "nickname"
        static let role = "role"
        static let classroomUUID = "classroom_uuid"
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
        static let approvals = "approvals"
        static let submissions = "submissions"
        static let classrooms = "classrooms"
        static let members = "members"

        static let requestUUID = "request_uuid"
        static let requesterProfile = "requester_profile"
        static let requesterRole = "requester_role"

        static let approverProfileInfo = "approver_profile_info"
        static let classroomInfo = "classroom_info"

        static let imgURL = "img_url"
        static let timeString = "time_string"
        static let title = "title"
        static let subtitle = "subtitle"
        static let nickname = "nickname"

        static let studentUserId = "student_user_id"
        static let studentNickname = "student_nickname"

    }

    struct QAKeys {
        static let questionUUID = "question_uuid"
        static let creator = "creator"
        static let nickname = "nickname"
        static let imgURL = "img_url"
        static let role = "role"
        static let anonymous = "anonymous"
        static let content = "content"
        static let answerCount = "answer_count"
        static let schoolUUID = "school_uuid"
        static let classroomUUID = "classroom_uuid"
        static let classroomName = "classroom_name"
        static let answerUUID = "answer_uuid"
        static let agree = "agree"
        static let agreeCount = "agree_count"
        static let disagreeCount = "disagree_count"
        static let createdTimestamp = "created_timestamp"
        static let updatedTimestamp = "updated_timestamp"

        static let pageNumber = "page_number"
        static let filterType = "filter_type"
    }
}

