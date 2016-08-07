//
//  EditTextViewTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 8/6/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit
import SZTextView

class EditTextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: SZTextView!

    var contentText: String?
    var placeholder: String = "编辑内容"

    typealias CompleteEditClosureType = (text: String) -> Void
    var completeEditBlock: CompleteEditClosureType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None

        textView.placeholder = placeholder
        if let contentText = contentText {
            textView.text = contentText
        }
        textView.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configurate(completeEdit: CompleteEditClosureType) {
        self.completeEditBlock = completeEdit
    }

    func textViewDidChange(textView: UITextView) {
        contentText = textView.text
        self.completeEditBlock!(text: contentText!)
    }
    
}
