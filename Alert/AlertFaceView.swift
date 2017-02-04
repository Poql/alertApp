//
//  AlertFaceView.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class AlertFaceView: UIView {
    @IBOutlet private var matterLabel: UILabel!

    @IBOutlet private var dateLabel: UILabel!

    @IBOutlet private var descriptionLabel: UILabel!

    // MARK: - Public

    func configure(matter: String, date: String, description: String) {
        matterLabel.text = matter
        dateLabel.text = date
        descriptionLabel.text = description
    }
}


