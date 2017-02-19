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
}
