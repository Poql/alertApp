//
//  IdentifiableEntity.swift
//  Alert
//
//  Created by Gaétan Zanella on 27/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol IdentifiableEntity {
    var id: String { get }
}

extension IdentifiableEntity where Self : Hashable {
    var hashValue: Int {
        return id.hashValue
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
