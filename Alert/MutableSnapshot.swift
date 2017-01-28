//
//  MutableSnapshot.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct MutableSnapshot {
    var id: String
    var dictionary: [String : Any]
}

// MARK: - Snapshot

extension MutableSnapshot: Snapshot {}
