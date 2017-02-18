//
//  UserSnapshot + Firebase.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseAuth

extension FIRUser: UserSnapshot {
    var id: String {
        return uid
    }

    var name: String? {
        return displayName
    }
}

