//
//  AlertTableViewCell.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol AlertTableViewCellDelegate: class {
    func alertTableViewCellDidSelectApproveAction(_ cell: AlertTableViewCell)
    func alertTableViewCellDidSelectComplainAction(_ cell: AlertTableViewCell)
}

class AlertTableViewCell: UITableViewCell {

    fileprivate let approveActionView: AlertActionView = {
        let action = AlertActionView(frame: CGRect.zero)
        let decoration = "approval_feedback_decoration".localized
        let name = "approval_feedback_title".localized
        action.configure(decorationText: decoration, actionName: name)
        action.backgroundColor = UIColor.black
        return action
    }()

    fileprivate let complainActionView: AlertActionView = {
        let action = AlertActionView(frame: CGRect.zero)
        let decoration = "disclaim_feedback_decoration".localized
        let name = "disclaim_feedback_title".localized
        action.configure(decorationText: decoration, actionName: name)
        action.backgroundColor = UIColor.gz_darkRed
        return action
    }()

    private lazy var sideView: AlertSideView = {
        let view = AlertSideView(actions: [self.approveActionView, self.complainActionView])
        view.delegate = self
        return view
    }()

    private let faceView: AlertFaceView = UIView.fromNib()

    private lazy var facetView: FacetView = FacetView(faceView: self.faceView, sideView: self.sideView)

    weak var delegate: AlertTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Public

    func configure(with viewModel: AlertViewModel) {
        faceView.configure(
            matter: viewModel.matterName,
            date: viewModel.triggerDate,
            description: viewModel.description,
            disclaimsCount: viewModel.disclaimsCount,
            approvalsCount: viewModel.approvalsCount
        )
    }

    func rotate() {
        facetView.switchFace()
    }

    // MARK: - Private

    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.gz_gray
        contentView.gz_pinSubview(facetView, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}

extension AlertTableViewCell: AlertSideViewDelegate {
    func alertSideView(_ view: AlertSideView, didTrigger action: AlertActionView) {
        if action == approveActionView {
            delegate?.alertTableViewCellDidSelectApproveAction(self)
        } else if action == complainActionView {
            delegate?.alertTableViewCellDidSelectComplainAction(self)
        }
        
    }
}
