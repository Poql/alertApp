//
//  FormWorkerImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

class FormWorkerImplementation {
    fileprivate let formRepository: FormRepository
    fileprivate let authenticationRepository: AuthenticationRepository
    fileprivate let cacheRepository: CacheRepository
    fileprivate let viewModelMapper = FormViewModelMapper()
    weak var viewContract: FormViewContract?

    init(
        formRepository: FormRepository,
        authenticationRepository: AuthenticationRepository,
        cacheRepository: CacheRepository) {
        self.formRepository = formRepository
        self.authenticationRepository = authenticationRepository
        self.cacheRepository = cacheRepository
    }
}

// MARK: - FormWorker

extension FormWorkerImplementation: FormWorker {
    func fetchForms() {
        viewContract?.willDispatch()
        formRepository.fetchForms { forms in
            let viewModels = forms.flatMap { self.viewModelMapper.mapViewModel(from: $0) }
            self.viewContract?.present(viewModels)
        }
    }

    func saveUserForm(withIdentifier id: String) {
        guard let user = authenticationRepository.currentUser, user.formId != id else { return }
        if let id = user.formId {
            formRepository.removeUser(user, fromFormWithIdentifier: id)
        }
        cacheRepository.purgeCache()
        formRepository.replaceUser(user, inFormWithIdentifier: id)
        authenticationRepository.setUserForm(formId: id)
    }
}
