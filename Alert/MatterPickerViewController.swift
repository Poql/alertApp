//
//  MatterPickerViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol MatterPickerViewControllerDelegate : class {
    func matterPickerViewController(_ controller: MatterPickerViewController, didSelect matter: MatterViewModel)
}

class MatterPickerViewController: BaseViewController {
    @IBOutlet fileprivate var tableView: UITableView!

    fileprivate var matters: Set<MatterViewModel> = []

    fileprivate var sortedMatters: [MatterViewModel] {
        return Array(matters).sorted { $0.name < $1.name }
    }

    private lazy var worker: MatterWorker = {
        return self.workerFactory.newMatterWorker(with: self)
    }()

    var selectedMatterId: String?

    weak var delegate: MatterPickerViewControllerDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset.left = BasicTableViewCellConstant.separatorInset
        tableView.register(cell: .fromNib(BasicTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        worker.beginSynchronisation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        worker.stopSynchronisation()
    }

    // MARK: - Private

    fileprivate func updateMatters(with matter: MatterViewModel) {
        matters.remove(matter)
        matters.insert(matter)
        tableView.reloadData()
        if let id = selectedMatterId, let index = sortedMatters.map({$0.id}).index(of: id) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    // MARK: - Action

    @IBAction func insertMatter(_ sender: Any) {
        let controller = UIAlertController(title: "Nouvelle matère", message: "", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let name = controller.textFields?.first?.text
            let matter = MutableMatter(name: name)
            self.worker.addMatter(matter)
        }))
        controller.addAction(UIAlertAction(title: "Annuler", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension MatterPickerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let matter = sortedMatters[indexPath.row]
        delegate?.matterPickerViewController(self, didSelect: matter)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isInteractive = sortedMatters[indexPath.row].isInteractive
        return isInteractive ? indexPath : nil
    }
}

// MARK: - UITableViewDataSource

extension MatterPickerViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMatters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasicTableViewCell = tableView.dequeueCell()
        let viewModel = sortedMatters[indexPath.row]
        cell.configure(value: viewModel.name)
        cell.isInteractive = viewModel.isInteractive
        return cell
    }
}

// MARK: - MatterViewContract

extension MatterPickerViewController : MatterViewContract {
    func update(_ matter: MatterViewModel) {
        updateMatters(with: matter)
    }

    func add(_ matter: MatterViewModel) {
        updateMatters(with: matter)
    }

    func handleError(_ error: ApplicationError) {
    }
}
