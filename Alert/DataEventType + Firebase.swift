//
//  DataEventType + Firebase.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataEventType {
    var firebaseType: FIRDataEventType {
        switch self {
        case .added:
            return .childAdded
        case .updated:
            return .childChanged
        case .removed:
            return .childRemoved
        }
    }
}
