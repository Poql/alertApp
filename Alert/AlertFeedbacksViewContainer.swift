//
//  AlertFeedbacksViewContainer.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let feedbacksSpacing: CGFloat = 8
    static let feedbackHeight: CGFloat = 24
    static let feedbackWidth: CGFloat = 46
}

class AlertFeedbacksViewContainer: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constant.feedbacksSpacing
        return stackView
    }()

    private let disclaimFeedbackView: AlertFeedbackView = {
        let view = AlertFeedbackView()
        view.color = UIColor.gz_darkRed
        view.countColor = UIColor.white
        view.title = "disclaim_feedback_decoration".localized
        return view
    }()

    private let approvalFeedbackView: AlertFeedbackView = {
        let view = AlertFeedbackView()
        view.color = UIColor.black
        view.countColor = UIColor.white
        view.title = "approval_feedback_decoration".localized
        return view
    }()

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

    func configure(disclaimsCount: Int, approvalsCount: Int) {
        approvalFeedbackView.configure(count: approvalsCount)
        disclaimFeedbackView.configure(count: disclaimsCount)
        approvalFeedbackView.isHidden = approvalsCount == 0
        approvalFeedbackView.isHidden = disclaimsCount == 0
    }

    // MARK: - private

    private func setupView() {
        setupFeedbackView(view: disclaimFeedbackView)
        setupFeedbackView(view: approvalFeedbackView)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        stackView.addArrangedSubview(approvalFeedbackView)
        stackView.addArrangedSubview(disclaimFeedbackView)
        approvalFeedbackView.configure(count: 0)
        disclaimFeedbackView.configure(count: 0)
    }

    private func setupFeedbackView(view: UIView) {
        let width = Constant.feedbackWidth
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
