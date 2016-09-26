//
//  QAAnswerTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/23/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class QAAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!

    var agreeCount: Int = 0
    var disagreeCount: Int = 0

    let qaKeys = GlobalKeys.QAKeys.self

    let placeholderImage = GlobalConstants.kProfileImagePlaceholder

    var answerUUID: String!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderProfileImageView()
    }

    func configurate(data: [String: AnyObject]) {
        let dataJSON = JSON(data)
        self.answerUUID = dataJSON[self.qaKeys.answerUUID].stringValue
        let classroomName = dataJSON[self.qaKeys.classroomName].stringValue
        let anonymous = dataJSON[self.qaKeys.anonymous].boolValue
        if anonymous {
            self.profileImageView.image = self.placeholderImage
            self.authorLabel.text = "匿名 来自于班级 \(classroomName)"
        } else {
            let nickname = dataJSON[self.qaKeys.nickname].stringValue
            let imgURL = dataJSON[self.qaKeys.imgURL].stringValue
            self.profileImageView.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: self.placeholderImage)
            self.authorLabel.text = "\(nickname) 来自于班级 \(classroomName)"
        }
        let content = dataJSON[self.qaKeys.content].stringValue
        self.contentLabel.text = content
        // agree and disagree button 
        agreeCount = dataJSON[self.qaKeys.agreeCount].intValue
        disagreeCount = dataJSON[self.qaKeys.disagreeCount].intValue
        self.agreeButton.setTitle("赞同（\(agreeCount)）", forState: .Normal)
        self.disagreeButton.setTitle("反对（\(disagreeCount)）", forState: .Normal)
    }

    private func renderProfileImageView() {
        self.profileImageView.layer.cornerRadius = 12.5
        self.profileImageView.layer.masksToBounds = true
    }

    @IBAction func agreeButtonOnClick(sender: AnyObject) {
        self.agreeButton.setTitle("赞同（\(agreeCount+1)）", forState: .Normal)
        APIQAAnswerAgree().run(answerUUID, agree: true)
    }

    @IBAction func disagreeButtonOnClick(sender: AnyObject) {
        self.disagreeButton.setTitle("反对（\(disagreeCount+1)）", forState: .Normal)
        APIQAAnswerAgree().run(answerUUID, agree: false)
    }
    
    
    
}
