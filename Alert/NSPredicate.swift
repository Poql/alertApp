//
//  CoreData + PersistentEntity.swift
//  Alert
//
//  Created by Gaétan Zanella on 28/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

extension NSPredicate {
    static func entity(with id: String?) -> NSPredicate {
        return NSPredicate(format: "id == %@", id ?? "")
    }
}
