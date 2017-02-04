//
//  AlertWorker.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol AlertWorker {
    func fetchAlerts()
}

protocol AlertViewContract: class {
    func process(currentAlerts: [AlertViewModel])
    func update(alert: AlertViewModel)
    func remove(alert: AlertViewModel)
}
