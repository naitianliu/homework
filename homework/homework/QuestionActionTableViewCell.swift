//
//  QuestionActionTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 9/19/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionActionTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addAnswerButton: UIButton!

    let qaKeys = GlobalKeys.QAKeys.self

    let placeholderImage = GlobalConstants.kProfileImagePlaceholder

    typealias AddAnswerTypeClosure = () -> Void
    var addAnswerBlock: AddAnswerTypeClosure?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);

        self.selectionStyle = .None

        self.renderAddAnswerButton()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(data: [String: AnyObject], addAnswerClicked: AddAnswerTypeClosure) {
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

        self.addAnswerBlock = addAnswerClicked
    }
    
    @IBAction func favoriteButtonOnClick(sender: AnyObject) {

    }

    @IBAction func addAnswerButtonOnClick(sender: AnyObject) {
        self.addAnswerBlock!()
    }

    private func renderAddAnswerButton() {
        self.addAnswerButton.layer.cornerRadius = 6
        self.addAnswerButton.layer.masksToBounds = true
    }


}
