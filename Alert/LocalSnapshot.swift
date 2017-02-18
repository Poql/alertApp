//
//  LocalSnapshot.swift
//  Alert
//
//  Created by Gaétan Zanella on 15/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct LocalSnapshot {
    let id: String
    let dictionary: [String : Any]
}

// MARK: - Snapshot

extension LocalSnapshot: Snapshot {}
