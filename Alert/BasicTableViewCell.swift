//
//  BasicTableViewCell.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class BasicTableViewCell : UITableViewCell {

    @IBOutlet private var valueLabel: UILabel!

    @IBOutlet private var circularView: CircularView!

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
