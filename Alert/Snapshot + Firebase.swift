//
//  Snapshot + Firebase.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FIRDataSnapshot: Snapshot {
    var id: String {
        return key
    }

    var dictionary: [String : Any] {
        return (value as? [String : Any]) ?? [:]
    }
}
