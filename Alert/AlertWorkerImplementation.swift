//
//  AlertWorkerImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

class AlertWorkerImplementation {
    fileprivate let remoteRepository: AlertRepository

    fileprivate let cacheRepository: CacheRepository

    fileprivate var remoteHandles: Set<Int> = []

    fileprivate var cacheHandles: Set<Int> = []

    fileprivate var isObserving: Bool {
        return !(remoteHandles.isEmpty && cacheHandles.isEmpty)
    }

    weak var viewContract: AlertViewContract?

    init(repository: AlertRepository, cache: CacheRepository) {
        self.remoteRepository = repository
        self.cacheRepository = cache
    }

    deinit {
        endObservation()
    }

    // MARK: - Private

    fileprivate func beginObservation() {
        remoteHandles.insert(remoteRepository.observe(.added, with: alertAdded))
        remoteHandles.insert(remoteRepository.observe(.updated, with: alertUpdated))
        remoteHandles.insert(remoteRepository.observe(.removed, with: alertRemoved))
        cacheHandles.insert(cacheRepository.observe(.added, with: alertCacheAdded))
        cacheHandles.insert(cacheRepository.observe(.updated, with: alertCacheUpdated))
        cacheHandles.insert(cacheRepository.observe(.removed, with: alertCacheRemoved))
    }

    private func endObservation() {
        remoteHandles.forEach { remoteRepository.removeObserver(withHandle: $0) }
        remoteHandles.removeAll()
        cacheHandles.forEach { cacheRepository.removeObserver(withHandle: $0) }
        cacheHandles.removeAll()
    }

    // remote

    private func alertAdded(alert: Alert) {
        cacheRepository.update(alert: alert)
    }

    private func alertUpdated(alert: Alert) {
        cacheRepository.update(alert: alert)
    }

    private func alertRemoved(alert: Alert) {
        cacheRepository.remove(alert: alert)
    }

    // cache

    private func viewModel(from alert: Alert) -> AlertViewModel {
        return AlertViewModelMapper.alertViewModel(from: alert)
    }

    private func alertCacheAdded(alert: Alert) {
        viewContract?.update(alert: viewModel(from: alert))
    }

    private func alertCacheUpdated(alert: Alert) {
        viewContract?.update(alert: viewModel(from: alert))
    }

    private func alertCacheRemoved(alert: Alert) {
        viewContract?.remove(alert: viewModel(from: alert))
    }
}

// MARK: - AlertWorker

extension AlertWorkerImplementation: AlertWorker {
    func fetchAlerts() {
        if !isObserving {
            beginObservation()
        }
    }
}
