//
//  PersistentAlertMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 23/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData

struct PersistentAlertMapper {
    static func mapAlert(from persitentAlert: PersistentAlert) -> Alert? {
        guard
            let id = persitentAlert.id,
            let description = persitentAlert.alertDescription
        else {
            return nil
        }
        return Alert(id: id, description: description)
    }

    static func mapPersistentAlert(from alert: Alert, in context: NSManagedObjectContext) -> PersistentAlert {
        let persistentAlert = PersistentAlert(context: context)
        update(persistentAlert, with: alert)
        return persistentAlert
    }

    static func update(_ persistentAlert: PersistentAlert, with alert: Alert) {
        persistentAlert.id = alert.id
        persistentAlert.alertDescription = alert.description
    }
}
