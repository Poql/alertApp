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
}
