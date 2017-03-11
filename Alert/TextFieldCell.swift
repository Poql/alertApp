//
//  TextFieldCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func textFieldcell(_ cell: TextFieldCell, didEditText text: String?)
}

class TextFieldCell: UITableViewCell {
    @IBOutlet private var entitlementLabel: UILabel!
    
    @IBOutlet private var textField: UITextField!

    weak var delegate: TextFieldCellDelegate?

    var isEditable: Bool {
        set {
            textField.isUserInteractionEnabled = newValue
        }
        get {
            return textField.isUserInteractionEnabled
        }
    }

    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingChanged)
        entitlementLabel.font = UIFont.regularRubik(ofSize: 15)
        textField.font = UIFont.regularRubik(ofSize: 15)
    }

    // MARK: - Configuration

    func configure(entitlement: String?, placeholder: String?, text: String?) {
        entitlementLabel.isHidden = entitlement == nil
        entitlementLabel.text = entitlement
        textField.placeholder = placeholder
        textField.text = text
    }
    
    // MARK: - Actions
    
    func textFieldAction(_ sender: UITextField) {
        delegate?.textFieldcell(self, didEditText: sender.text)
    }
}
