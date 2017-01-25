//
//  Alert.swift
//  Alert
//
//  Created by Gaétan Zanella on 23/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct Alert {
    var id: String
    var description: String
}

// MARK: - Hashable

extension Alert: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(lhs: Alert, rhs: Alert) -> Bool {
    return lhs.id == rhs.id
}
