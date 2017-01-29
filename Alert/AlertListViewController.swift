//
//  AlertListViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class AlertListViewController: BaseViewController {
    @IBOutlet fileprivate var tableView: UITableView!

    private lazy var worker: AlertWorker = {
        return self.workerFactory.newAlertWorker(with: self)
    }()

    fileprivate var viewModels: Set<AlertViewModel> = []

    fileprivate var sortedViewModels: [AlertViewModel] {
        return Array(viewModels)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        worker.fetchAlerts()
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(cell: .fromClass(AlertTableViewCell.self))
    }
}

// MARK: - AlertViewContract

extension AlertListViewController: AlertViewContract {
    func update(alert: AlertViewModel) {
        viewModels.remove(alert)
        viewModels.insert(alert)
        tableView.reloadData()
    }

    func remove(alert: AlertViewModel) {
        viewModels.remove(alert)
        tableView.reloadData()
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
