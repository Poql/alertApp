//
//  AlertViewModel.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct AlertViewModel {
    var id: String
    var description: String
}

// MARK: - Hashable

extension AlertViewModel: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(lhs: AlertViewModel, rhs: AlertViewModel) -> Bool {
    return lhs.id == rhs.id
}
