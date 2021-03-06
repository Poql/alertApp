//
//  AlertListViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let topContentInset: CGFloat =  12
    static let estimatedRow: CGFloat = 200
}

class AlertListViewController: BaseViewController {

    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate lazy var worker: AlertWorker = {
        return self.workerFactory.newAlertWorker(with: self)
    }()

    fileprivate var viewModels: Set<AlertViewModel> = []

    fileprivate var sortedViewModels: [AlertViewModel] {
        return Array(viewModels).sorted { $0.orderRank < $1.orderRank }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segueIdentifier(from: segue), identifier == .alertCreation,
            let navController = segue.destination as? UINavigationController,
            let controller = navController.viewControllers.first as? AlertCreationViewController
        else {
            return
        }
        controller.delegate = self
    }

    // MARK: - Actions

    @IBAction private func addAlertAction(_ sender: UIBarButtonItem) {
        performSegue(with: .alertCreation, sender: self)
    }

    // MARK: - Private

    private func setupTableView() {
        view.backgroundColor = .gz_gray
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.contentInset.top += Constant.topContentInset
        tableView.register(cell: .fromClass(AlertTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRow
    }

    fileprivate func updateRow(at index: Int, with viewModel: AlertViewModel) {
        let indexPath = IndexPath(row: index, section: 0)
        let viewModel = sortedViewModels[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? AlertTableViewCell else { return }
        cell.configure(with: viewModel, animated: true)
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

    func handleError(_ error: ApplicationError) {
        showAlertView(title: error.title, message: error.message)
    }
}

// MARK: - UITableViewDataSource

extension AlertListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertTableViewCell = tableView.dequeueCell()
        let alert = sortedViewModels[indexPath.row]
        cell.configure(with: alert)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedViewModels.count
    }
}

// MARK: - AlertTableViewCellDelegate

extension AlertListViewController: AlertTableViewCellDelegate {
    func alertTableViewCellDidSelectApproveAction(_ cell: AlertTableViewCell) {
        guard let viewModel = viewModel(for: cell) else { return }
        worker.approveAlert(alertId: viewModel.id, formId: viewModel.formId)
    }

    func alertTableViewCellDidSelectComplainAction(_ cell: AlertTableViewCell) {
        guard let viewModel = viewModel(for: cell) else { return }
        worker.deprecateAlert(alertId: viewModel.id, formId: viewModel.formId)
    }

    private func viewModel(for cell: AlertTableViewCell) -> AlertViewModel? {
        guard let index = tableView.indexPath(for: cell)?.row else { return nil }
        return sortedViewModels[index]
    }
}

// MARK: - AlertCreationViewControllerDelegate

extension AlertListViewController : AlertCreationViewControllerDelegate {
    func alertCreationViewControllerWantsToDismiss(_ controller: AlertCreationViewController) {
        dismiss(animated: true, completion: nil)
    }

    func alertCreationViewController(_ controller: AlertCreationViewController, wantsToSend alert: MutableAlert) {
        dismiss(animated: true) {
            self.worker.insert(alert)
        }
    }
}

// MARK: - SegueHandler

extension AlertListViewController : SegueHandler {
    enum SegueIdentifier: String {
        case alertCreation = "AlertCreationViewController"
    }
}
