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

    let serverValue: ServerValue.Type

    func mapAlert(from snapshot: Snapshot) -> Alert? {
        guard
            let creationInterval = snapshot.dictionary["creation_date"] as? TimeInterval,
            let triggerInterval = snapshot.dictionary["trigger_date"] as? TimeInterval,
            let matterName = snapshot.dictionary["matter_name"] as? String
        else {
            return nil
        }
        let description = (snapshot.dictionary["description"] as? String) ?? ""
        let approvers = (snapshot.dictionary["approvers"] as? [String]) ?? []
        let disclaimers = (snapshot.dictionary["disclaimers"] as? [String]) ?? []
        return Alert(
            id: snapshot.id,
            description: description,
            matterName: matterName,
            creationDate: Date(timeIntervalSince1970: creationInterval),
            triggerDate: Date(timeIntervalSince1970: triggerInterval),
            approvers: approvers,
            disclaimers: disclaimers
        )
    }

    func snapshot(forNewAlert alert: MutableAlert, with id: String) -> Snapshot {
        var dictionary: [String : Any] = [:]
        if let description = alert.description {
            dictionary["description"] = description
        }
        if let triggerDate = alert.triggerDate {
            dictionary["trigger_date"] = dateValue(from: triggerDate)
        }
        if let creationDate = alert.creationDate {
            dictionary["creation_date"] = dateValue(from: creationDate)
        }
        if let matterName = alert.matterName {
            dictionary["matter_name"] = matterName
        }
        return LocalSnapshot(
            id: id,
            dictionary: dictionary
        )
    }

    func snapshot<T: MutableSnapshot>(forDeprecatedAlert snapshot: T, by user: User) -> T {
        return insertUser(user, atKey: "disclaimers", in: snapshot)
    }

    func snapshot<T: MutableSnapshot>(forApprovedAlert snapshot: T, by user: User) -> T {
        return insertUser(user, atKey: "approvers", in: snapshot)
    }

    // MARK: - Private

    private func dateValue(from recordDate:RecordDate) -> Any {
        switch recordDate {
        case let .localDate(date):
            return date.timeIntervalSince1970
        case .server:
            return serverValue.currentTime
        }
    }

    func insertUser<T: MutableSnapshot>(_ user: User, atKey key: String, in snapshot: T) -> T {
        var snapshot = snapshot
        var disclaimers = Set((snapshot.dictionary[key] as? [String]) ?? [])
        if disclaimers.contains(user.id) {
            disclaimers.remove(user.id)
        } else {
            disclaimers.insert(user.id)
        }
        var dictionary = snapshot.dictionary
        dictionary[key] = Array(disclaimers)
        snapshot.dictionary = dictionary
        return snapshot
    }
}

