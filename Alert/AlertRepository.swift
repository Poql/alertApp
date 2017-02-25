//
//  AlertRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 24/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol AlertRepository {
    func observe(_ type: DataEventType, formId: String, with block: @escaping (Alert) -> Void) -> Int
    func removeObserver(withHandle handle: Int)
    func insert(alert: MutableAlert, formId: String)
    func approveAlert(alertId: String, formId: String, user: User)
    func deprecateAlert(alertId: String, formId: String, user: User)
}
