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
    fileprivate let viewModelMapper = FormViewModelMapper()
    weak var viewContract: FormViewContract?

    init(formRepository: FormRepository) {
        self.formRepository = formRepository
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
}
