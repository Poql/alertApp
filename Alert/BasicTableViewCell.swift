//
//  BasicTableViewCell.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

struct BasicTableViewCellConstant {
    static let separatorInset: CGFloat = 44
}

class BasicTableViewCell : UITableViewCell {

    @IBOutlet private var valueLabel: UILabel!

    @IBOutlet private var circularView: CircularView!

    var isInteractive: Bool = true {
        didSet {
            circularView.isHidden = !isInteractive
            valueLabel.textColor = isInteractive ? .black : .lightGray
        }
    }

    // MARK: - UITableViewCell

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        circularView.fillColor = selected ? .black : .clear
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        valueLabel.font = UIFont.regularRubik(ofSize: 15)
    }

    // MARK: - Public

    func configure(value: String) {
        valueLabel.text = value
    }
}
