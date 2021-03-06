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

    fileprivate let authenticationRepository: AuthenticationRepository

    fileprivate var remoteHandles: Set<Int> = []

    fileprivate var cacheHandles: Set<Int> = []

    fileprivate var isObserving: Bool {
        return !(remoteHandles.isEmpty && cacheHandles.isEmpty)
    }

    private let mapper = AlertViewModelMapper()

    weak var viewContract: AlertViewContract?

    init(repository: AlertRepository, cache: CacheRepository, authentication: AuthenticationRepository) {
        self.remoteRepository = repository
        self.cacheRepository = cache
        self.authenticationRepository = authentication
    }

    deinit {
        endObservation()
    }

    // MARK: - Private

    fileprivate func beginObservation(formId: String) {
        remoteHandles.insert(remoteRepository.observe(.added, formId: formId, with: alertAdded))
        remoteHandles.insert(remoteRepository.observe(.updated, formId: formId, with: alertUpdated))
        remoteHandles.insert(remoteRepository.observe(.removed, formId: formId, with: alertRemoved))
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

    fileprivate func viewModel(from alert: Alert) -> AlertViewModel {
        return mapper.alertViewModel(from: alert)
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
    func approveAlert(alertId: String, formId: String) {
        guard let user = authenticationRepository.currentUser else {
            viewContract?.handleError(.userNotLoggedIn)
            return
        }
        remoteRepository.approveAlert(alertId: alertId, formId: formId, user: user)
    }

    func deprecateAlert(alertId: String, formId: String) {
        guard let user = authenticationRepository.currentUser else {
            viewContract?.handleError(.userNotLoggedIn)
            return
        }
        remoteRepository.deprecateAlert(alertId: alertId, formId: formId, user: user)
    }

    func fetchAlerts() {
        guard let formId = authenticationRepository.currentUser?.formId else {
            viewContract?.handleError(.userFormNotFound)
            return
        }
        cacheRepository.fetchCurrentCache { alerts in
            self.viewContract?.process(currentAlerts: alerts.map { self.viewModel(from: $0) })
        }
        if !isObserving {
            beginObservation(formId: formId)
        }
    }

    func insert(_ alert: MutableAlert) {
        guard let formId = authenticationRepository.currentUser?.formId else {
            viewContract?.handleError(.userFormNotFound)
            return
        }
        remoteRepository.insert(alert: alert, formId: formId)
    }
}
