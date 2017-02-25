//
//  FormMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct FormMapper {
    func form(from snapshot: Snapshot) -> Form? {
        guard let name = snapshot.dictionary["name"] as? String else { return nil }
        return Form(id: snapshot.id, name: name)
    }
}

