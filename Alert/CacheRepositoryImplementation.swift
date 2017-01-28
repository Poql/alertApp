//
//  CacheRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 23/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData

class CacheRepositoryImplementation: ObservableRepository<Alert> {

    // a dummy cache
    private var cache: Set<Alert> = []

    // MARK: - Private methods

    fileprivate func updateInBackground(_ alert: Alert) {
        cache.remove(alert)
        cache.insert(alert)
        notifyObservers(.updated, for: alert)
    }

    fileprivate func removeInBackground(_ alert: Alert) {
        cache.remove(alert)
        notifyObservers(.removed, for: alert)
    }

    fileprivate func fetchCurrentAlerts() {
        for alert in cache {
            notifyObservers(.updated, for: alert)
        }
    }
}

// MARK: - CacheRepository

extension CacheRepositoryImplementation: CacheRepository {

    func observe(_ type: DataEventType, with block: @escaping (Alert) -> Void) -> Int {
        return attachObserver(type, with: block)
    }

    func removeObserver(withHandle handle: Int) {
        removeAttachedObserver(withHandle: handle)
    }

    func update(alert: Alert) {
        updateInBackground(alert)
    }

    func remove(alert: Alert) {
        removeInBackground(alert)
    }
}
