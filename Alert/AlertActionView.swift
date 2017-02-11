//
//  AlertActionView.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let textSpacing: CGFloat = 4
}

class AlertActionView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.textSpacing
        return stackView
    }()

    private let decorationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumSFMono(ofSize: 30)
        label.textAlignment = .center
        return label
    }()

    private let actionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mediumSFMono(ofSize: 15)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Public

    func configure(decorationText: String, actionName: String) {
        decorationLabel.text = decorationText
        actionNameLabel.text = actionName
    }

    // MARK: - Private

    private func setupView() {
        decorationLabel.textColor = UIColor.white
        actionNameLabel.textColor = UIColor.white
        backgroundColor = UIColor.black
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        stackView.addArrangedSubview(decorationLabel)
        stackView.addArrangedSubview(actionNameLabel)
    }
}
