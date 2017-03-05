//
//  BigButton.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class BigButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    // MARK: - UIView

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }

    // MARK: - Private

    private func setupButton() {
        tintColor = .white
        backgroundColor = .black
        titleLabel?.font = UIFont.regularRubik(ofSize: 24)
    }
}
