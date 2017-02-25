//
//  FormPickerViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class FormPickerViewController: BaseViewController {
    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate lazy var worker: FormWorker = self.workerFactory.newFormWorker(with: self)

    fileprivate var viewModels: [FormViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        worker.fetchForms()
    }

    // MARK: - Private

    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: .fromClass(UITableViewCell.self))
    }

    fileprivate func didSelectForm(withIdentifier id: String) {
        worker.saveUserForm(withIdentifier: id)
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

// MARK: - UITableViewDelegate

extension FormPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        didSelectForm(withIdentifier: viewModel.id)
    }
}

// MARK: - UITableViewDataSource

extension FormPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell()
        cell.textLabel?.text = viewModels[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
}
