//
//  WorkerFactory.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol WorkerFactory {
    func newAlertWorker(with viewContract: AlertViewContract) -> AlertWorker
    func newAuthenticationWorker(with viewContract: AuthenticationViewContract) -> AuthenticationWorker
}

class WorkerFactoryImplementation {
    // TODO (gz) 2017-02-17 rename the repositories
    let authentication = AuthenticationRepositoryImplementation()
    let repository = AlertRepositoryImplementation()
    let cache = CacheRepositoryImplementation()
}

// MARK: - WorkerFactory

extension WorkerFactoryImplementation: WorkerFactory {
    func newAlertWorker(with viewContract: AlertViewContract) -> AlertWorker {
        let worker = AlertWorkerImplementation(repository: repository, cache: cache, authentication: authentication)
        worker.viewContract = viewContract
        return worker
    }

    func newAuthenticationWorker(with viewContract: AuthenticationViewContract) -> AuthenticationWorker {
        let worker = AuthenticationWorkerImplementation(repository: authentication)
        worker.viewContract = viewContract
        return worker
    }
}
