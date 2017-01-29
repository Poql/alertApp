//
//  AlertSideView.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol AlertSideViewDelegate: class {
    func alertSideView(_ view: AlertSideView, didTrigger action: AlertActionView)
}

class AlertSideView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let actions: [AlertActionView]
    
    weak var delegate: AlertSideViewDelegate?

    init(actions: [AlertActionView]) {
        self.actions = actions
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupView() {
        gz_pinSubview(stackView)
        for action in actions {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction(_:)))
            action.addGestureRecognizer(recognizer)
            stackView.addArrangedSubview(action)
        }
    }

    // MARK: - Action

    @objc private func tapRecognizerAction(_ sender: AlertActionView) {
        delegate?.alertSideView(self, didTrigger: sender)
    }
}
