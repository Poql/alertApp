//
//  FormRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol FormRepository {
    func fetchForms(completionBlock block: @escaping ([Form]) -> Void)
    func saveUser(_ user: User, inFormWithIdentifier id: String)
    func removeUser(_ user: User, fromFormWithIdentifier id: String)
}
