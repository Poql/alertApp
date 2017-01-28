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

    fileprivate var alerts: Set<Alert> = []

    fileprivate var sortedAlerts: [Alert] {
        return Array(alerts)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        worker.fetchAlerts()
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - AlertViewContract

extension AlertListViewController: AlertViewContract {
    func update(alert: Alert) {
        alerts.remove(alert)
        alerts.insert(alert)
        tableView.reloadData()
    }

    func remove(alert: Alert) {
        alerts.remove(alert)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension AlertListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let alert = sortedAlerts[indexPath.row]
        cell.textLabel?.text = alert.description
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedAlerts.count
    }
}
