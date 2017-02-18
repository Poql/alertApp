//
//  BaseViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var workerFactory: WorkerFactory = {
        return AppDelegate.shared.workerFactory
    }()

    // MARK: - Public

    func showAlertView(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertTitle = "ok_alert_action".localized
        alertController.addAction(UIAlertAction(title: alertTitle, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
