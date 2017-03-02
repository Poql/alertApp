//
//  MatterMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct MatterMapper {
    func matter(from snapshot: Snapshot) -> Matter? {
        guard let name = snapshot.dictionary["name"] as? String else { return nil }
        return Matter(id: snapshot.id, name: name)
    }

    func snapshot(forNew matter: MutableMatter, identifier: String) -> Snapshot {
        return LocalSnapshot(id: identifier, dictionary: ["name": matter.name ?? ""])
    }
}
