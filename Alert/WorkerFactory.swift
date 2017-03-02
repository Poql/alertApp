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
    func newFormWorker(with viewContract: FormViewContract) -> FormWorker
    func newMatterWorker(with viewContract: MatterViewContract) -> MatterWorker
}

class WorkerFactoryImplementation {
    // TODO (gz) 2017-02-17 rename the repositories
    lazy var authentication = AuthenticationRepositoryImplementation()
    lazy var repository = AlertRepositoryImplementation()
    lazy var cache = CacheRepositoryImplementation()
    lazy var formRepository = FormRepositoryImplementation()
    lazy var matterRepository = MatterRepositoryImplementation()
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

    func newFormWorker(with viewContract: FormViewContract) -> FormWorker {
        let worker = FormWorkerImplementation(
            formRepository: formRepository,
            authenticationRepository: authentication,
            cacheRepository: cache
        )
        worker.viewContract = viewContract
        return worker
    }

    func newMatterWorker(with viewContract: MatterViewContract) -> MatterWorker {
        let worker = MatterWorkerImplementation(
            matterRepository: matterRepository,
            authenticationRepository: authentication
        )
        worker.viewContract = viewContract
        return worker
    }
}
