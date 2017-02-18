//
//  MutableSnapshot + Firebase.swift
//  Alert
//
//  Created by Gaétan Zanella on 15/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FIRMutableData: MutableSnapshot {
    var id: String? {
        return key
    }

    var dictionary: [String : Any] {
        set {
            value = newValue
        }
        get {
            return value as? [String : Any] ?? [:]
        }
    }
}
