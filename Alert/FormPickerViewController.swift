//
//  FormPickerViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let cellHeight: CGFloat = 40
}

class FormPickerViewController: BaseViewController {

    @IBOutlet private var selectionButton: BigButton!

    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate lazy var worker: FormWorker = self.workerFactory.newFormWorker(with: self)

    fileprivate var viewModels: [FormViewModel] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        worker.fetchForms()
    }

    // MARK: - Actions

    @IBAction private func selectionButtonAction(_ sender: Any) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let viewModel = viewModels[indexPath.row]
        worker.saveUserForm(withIdentifier: viewModel.id)
    }


    // MARK: - Private

    private func setupView() {
        titleLabel.font = UIFont.mediumSFMono(ofSize: 20)
        titleLabel.text = "matter_selection_title".localized
        selectionButton.setTitle("matter_selection_button".localized, for: .normal)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: .fromNib(BasicTableViewCell.self))
    }
}

// MARK: - FormViewContract

extension FormPickerViewController: FormViewContract {
    func willDispatch() {}

    func present(_ forms: [FormViewModel]) {
        viewModels = forms
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FormPickerViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasicTableViewCell = tableView.dequeueCell()
        let viewModel = viewModels[indexPath.row]
        cell.configure(value: viewModel.name)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
}

// MARK: - UITableViewDelegate

extension FormPickerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }
}
