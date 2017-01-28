//
//  AlertMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AlertMapper {
    static func mapAlert(from snapshot: Snapshot) -> Alert? {
        guard let dictionary = snapshot.dictionary as? [String : String] else { return nil }
        return Alert(id: snapshot.id, description: dictionary["description"] ?? "")
    }

    static func snapshot(forNewAlert alert: Alert, with id: String) -> Snapshot {
        return MutableSnapshot(
            id: alert.id,
            dictionary: [
                "description": alert.description
            ]
        )
    }
}

