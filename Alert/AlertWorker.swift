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
    func insert(_ alert: MutableAlert)
    func approveAlert(alertId: String, formId: String)
    func deprecateAlert(alertId: String, formId: String)
}

protocol AlertViewContract: class {
    func process(currentAlerts: [AlertViewModel])
    func update(alert: AlertViewModel)
    func remove(alert: AlertViewModel)
    func handleError(_ error: ApplicationError)
}
