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
    static let height: CGFloat = 24
    static let width: CGFloat = 46
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

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: Constant.width, height: size.height)
    }

    // MARK: - Public

    func configure(count: Int) {
        countLabel.text = "\(count)"
    }

    // MARK: - Private

    private func setupView() {
        layer.cornerRadius = Constant.cornerRadius
        pinSubview(stackView, insets: Constant.stackViewInsets)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
    }

    private func pinSubview(_ subview: UIView, insets: UIEdgeInsets) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        let leadingConstraint = subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left)
        leadingConstraint.priority = UILayoutPriorityDefaultHigh
        leadingConstraint.isActive = true
        let topConstraint = subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        topConstraint.priority = UILayoutPriorityDefaultHigh
        topConstraint.isActive = true
    }
}
