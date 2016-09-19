//
//  QuestionTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

    let qaKeys = GlobalKeys.QAKeys.self

    let placeholderImage = GlobalConstants.kProfileImagePlaceholder

    typealias AnswerButtonClickedClosureType = (questionUUID: String) -> Void
    var answerButtonBlock: AnswerButtonClickedClosureType?

    var questionUUID: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);

        self.selectionStyle = .None

        self.renderContainerView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.renderProfileImageView()
    }

    func configurate(data: [String: AnyObject], answerButtonClicked: AnswerButtonClickedClosureType) {
        let dataJSON = JSON(data)
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
        let answerCount = dataJSON[self.qaKeys.answerCount].intValue
        self.infoLabel.text = "\(answerCount) 个回答"

        self.questionUUID = dataJSON[self.qaKeys.questionUUID].string
        self.answerButtonBlock = answerButtonClicked
    }
    
    @IBAction func answerButtonOnClick(sender: AnyObject) {
        if let questionUUID = questionUUID {
            self.answerButtonBlock!(questionUUID: questionUUID)
        }
    }

    private func renderContainerView() {
        self.containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.containerView.layer.borderWidth = 0.5
    }

    private func renderProfileImageView() {
        self.profileImageView.layer.cornerRadius = 12.5
        self.profileImageView.layer.masksToBounds = true
    }
}
