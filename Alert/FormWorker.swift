//
//  FormWorker.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol FormWorker {
    func fetchForms()
    func saveUserForm(withIdentifier id: String)
}

protocol FormViewContract: class {
    func willDispatch()
    func present(_ forms: [FormViewModel])
}
