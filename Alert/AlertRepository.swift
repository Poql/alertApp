//
//  AlertRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 24/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol AlertRepository {
    func observe(_ type: DataEventType, with block: @escaping (Alert) -> Void) -> Int
    func removeObserver(withHandle handle: Int)
    func insert(alert: MutableAlert)
    func approveAlert(with alertId: String, user: User)
    func deprecateAlert(with alertId: String, user: User)
}
