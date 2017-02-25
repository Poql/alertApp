//
//  UserMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct UserMapper {
    func mapUser(from snaphot: UserSnapshot) -> User? {
        guard
            let email = snaphot.email,
            let name = snaphot.name
        else {
            return nil
        }
        return User(id: snaphot.id, email: email, name: name, formId: nil)
    }

    func userFormId(from snapshot: Snapshot) -> String? {
        return snapshot.dictionary["formId"] as? String
    }

    func userSnapshotForUserFormIdChange(formId: String, userId: String) -> Snapshot {
        return LocalSnapshot(
            id: userId,
            dictionary: ["formId" : formId]
        )
    }
}
