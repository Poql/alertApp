//
//  AlertViewModel.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct AlertViewModel {
    let id: String
    let description: String
    let matterName: String
    let creationDate: String
    let triggerDate: String
    let disclaimsCount: Int
    let approvalsCount: Int
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
