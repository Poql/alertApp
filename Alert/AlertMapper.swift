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
        return Alert(
            id: snapshot.id,
            description: description,
            matterName: matterName,
            creationDate: Date(timeIntervalSince1970: creationInterval),
            triggerDate: Date(timeIntervalSince1970: triggerInterval)
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
        if alert.creationDate == nil {
            dictionary["creation_date"] = serverValue.currentTime
        }
        if let matterName = alert.matterName {
            dictionary["matter_name"] = matterName
        }
        return MutableSnapshot(
            id: id,
            dictionary: dictionary
        )
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
}

