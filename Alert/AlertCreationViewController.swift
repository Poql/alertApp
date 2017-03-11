//
//  AlertCreationViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let descriptionCellHeight: CGFloat = 150
    static let matterCellHeight: CGFloat = 44
}

class AlertCreationViewController: BaseViewController {

    @IBOutlet fileprivate var sendButton: BigButton!

    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate var mutableAlert = MutableAlert()

    enum Row: Int {
        case matter, description
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? MatterPickerViewController else { return }
        controller.selectedMatterId = mutableAlert.matterId
        controller.delegate = self
    }

    // MARK: - Action

    @IBAction private func sendButtonAction(_ sender: UIButton) {
    }

    // MARK: - Private

    private func setupView() {
        sendButton.setTitle("send_alert_button_title".localized, for: .normal)
        sendButton.backgroundColor = .gz_darkRed
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func setupTableView() {
        tableView.register(cell: .fromNib(TextFieldCell.self))
        tableView.register(cell: .fromNib(TextViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TextViewCell

extension AlertCreationViewController : TextViewCellDelegate {
    func textViewCell(_ cell: TextViewCell, didChange text: String?) {
        mutableAlert.description = text
    }
}

// MARK: - UITableViewDelegate

extension AlertCreationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(with: .matter, sender: self)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let row = Row(rawValue: indexPath.row), row == .matter else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        switch row {
        case .matter:
            return Constant.matterCellHeight
        case .description:
            return Constant.descriptionCellHeight
        }
    }
}

// MARK: - UITableViewDataSource

extension AlertCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        switch row {
        case .matter:
            let cell: TextFieldCell = tableView.dequeueCell()
            cell.isEditable = false
            cell.accessoryType = .disclosureIndicator
            cell.configure(
                entitlement: "alert_creation_description_entitlement".localized,
                placeholder: "alert_creation_description_placeholder".localized,
                text: mutableAlert.matterName
            )
            return cell
        case .description:
            let cell: TextViewCell = tableView.dequeueCell()
            cell.configure(
                placeholder: "alert_creation_matter_placeholder".localized,
                text: mutableAlert.description
            )
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - MatterPickerViewControllerDelegate

extension AlertCreationViewController : MatterPickerViewControllerDelegate {
    func matterPickerViewController(_ controller: MatterPickerViewController, didSelect matter: MatterViewModel) {
        mutableAlert.matterId = matter.id
        mutableAlert.matterName = matter.name
        let _ = navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

// MARK: - SegueHandler

extension AlertCreationViewController : SegueHandler {
    enum SegueIdentifier: String {
        case matter = "matter"
    }
}
