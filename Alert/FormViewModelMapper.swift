//
//  FormViewModelMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation


struct FormViewModelMapper {
    func mapViewModel(from form: Form) -> FormViewModel {
        return FormViewModel(id: form.id, name: form.name)
    }
}
