//
//  AlertFeedbackView.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let labelsSpacing: CGFloat = 0
    static let cornerRadius: CGFloat = 4
    static let stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
}

class AlertFeedbackView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.labelsSpacing
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumSFMono(ofSize: 13)
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.mediumSFMono(ofSize: 12)
        return label
    }()

    var color: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }

    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }

    var countColor: UIColor? {
        set {
            countLabel.textColor = newValue
        }
        get {
            return countLabel.textColor
        }
    }

    // MARK: - UIView

    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Public

    func configure(count: Int) {
        countLabel.text = "\(count)"
    }

    // MARK: - Private

    private func setupView() {
        layer.cornerRadius = Constant.cornerRadius
        gz_pinSubview(stackView, insets: Constant.stackViewInsets)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
    }
}
