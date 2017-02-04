//
//  AlertListViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let estimatedRow: CGFloat = 200
}

class AlertListViewController: BaseViewController {

    @IBOutlet fileprivate var tableView: UITableView!

    private lazy var worker: AlertWorker = {
        return self.workerFactory.newAlertWorker(with: self)
    }()

    fileprivate var viewModels: Set<AlertViewModel> = []

    fileprivate var sortedViewModels: [AlertViewModel] {
        return Array(viewModels)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        worker.fetchAlerts()
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(cell: .fromClass(AlertTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRow
    }

    fileprivate func updateRow(at index: Int, with viewModel: AlertViewModel) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    fileprivate func insertRow(at index: Int, with viewModel: AlertViewModel) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    fileprivate func removeRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - AlertViewContract

extension AlertListViewController: AlertViewContract {
    func process(currentAlerts: [AlertViewModel]) {
        viewModels = Set(currentAlerts)
        tableView.reloadData()
    }

    func update(alert: AlertViewModel) {
        let isUpdated = viewModels.contains(alert)
        viewModels.remove(alert)
        viewModels.insert(alert)
        guard let index = sortedViewModels.index(of: alert) else { return }
        if isUpdated {
            updateRow(at: index, with: alert)
            return
        }
        insertRow(at: index, with: alert)
    }

    func remove(alert: AlertViewModel) {
        guard let index = sortedViewModels.index(of: alert) else { return }
        viewModels.remove(alert)
        removeRow(at: index)
    }
}

// MARK: - UITableViewDataSource

extension AlertListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertTableViewCell = tableView.dequeueCell()
        let alert = sortedViewModels[indexPath.row]
        cell.configure(with: alert)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedViewModels.count
    }
}
