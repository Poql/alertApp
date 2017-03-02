//
//  MatterWorkerImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

class MatterWorkerImplementation {

    fileprivate var matterMapper = MatterViewModelMapper()

    fileprivate let matterRepository: MatterRepository

    fileprivate let authenticationRepository: AuthenticationRepository

    fileprivate var handle: Int?

    weak var viewContract: MatterViewContract?

    init(matterRepository: MatterRepository, authenticationRepository: AuthenticationRepository) {
        self.matterRepository = matterRepository
        self.authenticationRepository = authenticationRepository
    }
}

// MARK: - MatterWorker

extension MatterWorkerImplementation : MatterWorker {
    func addMatter(_ matter: MutableMatter) {
        guard let formId = authenticationRepository.currentUser?.formId else { return }
        matterRepository.insert(matter, inFormWihIdentifier: formId)
    }

    func beginSynchronisation() {
        guard let formId = authenticationRepository.currentUser?.formId else { return }
        handle = matterRepository.observe(.added, formId: formId) { (matter, state) in
            let isCommited = state == .commited
            let viewModel = self.matterMapper.viewModel(from: matter, isCommited: isCommited)
            self.viewContract?.add(viewModel)
        }
    }

    func stopSynchronisation() {
        guard
            let formId = authenticationRepository.currentUser?.formId,
            let handle = handle
        else  {
            return
        }
        matterRepository.removeObserver(formId: formId, handle: handle)
    }
}
