//
//  TextViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol TextViewCellDelegate : class {
    func textViewCell(_ cell: TextViewCell, didChange text: String?)
}

class TextViewCell : UITableViewCell {

    @IBOutlet var textView: UITextView!
    
    fileprivate var placeholder = ""

    weak var delegate: TextViewCellDelegate?

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Configuration

    func configure(placeholder: String, text: String?) {
        self.placeholder = placeholder
        textView.text = text ?? placeholder
        textView.textColor = text == nil ? .lightGray : .black
    }

    // MARK: - Private

    private func setupViews() {
        textView.contentInset = UIEdgeInsets.zero
        textView.delegate = self
        textView.font = UIFont.regularRubik(ofSize: 15)
    }
}

// MARK: - UITextViewDelegate

extension TextViewCell : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == placeholder && textView.textColor == .lightGray else { return }
        textView.text = nil
        textView.textColor = .black
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        textView.text = placeholder
        textView.textColor = .lightGray
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewCell(self, didChange: textView.text)
    }
}
