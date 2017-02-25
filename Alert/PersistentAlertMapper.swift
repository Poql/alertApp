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
    static func mapAlert(from persistentAlert: PersistentAlert) -> Alert? {
        guard
            let id = persistentAlert.id,
            let description = persistentAlert.alertDescription,
            let creationDate = persistentAlert.creationDate,
            let triggerDate = persistentAlert.triggerDate,
            let matterName = persistentAlert.matterName,
            let approvers = persistentAlert.approvers as? [String],
            let disclaimers = persistentAlert.disclaimers as? [String],
            let formId = persistentAlert.formId
        else {
            return nil
        }
        return Alert(
            id: id,
            formId: formId,
            description: description,
            matterName: matterName,
            creationDate: creationDate as Date,
            triggerDate: triggerDate as Date,
            approvers: approvers,
            disclaimers: disclaimers
        )
    }

    static func mapPersistentAlert(from alert: Alert, in context: NSManagedObjectContext) -> PersistentAlert {
        let persistentAlert = PersistentAlert(context: context)
        update(persistentAlert, with: alert)
        return persistentAlert
    }

    static func update(_ persistentAlert: PersistentAlert, with alert: Alert) {
        persistentAlert.id = alert.id
        persistentAlert.alertDescription = alert.description
        persistentAlert.creationDate = alert.creationDate as NSDate?
        persistentAlert.triggerDate = alert.triggerDate as NSDate?
        persistentAlert.matterName = alert.matterName
        persistentAlert.approvers = alert.approvers as NSObject?
        persistentAlert.disclaimers = alert.disclaimers as NSObject?
        persistentAlert.formId = alert.formId
    }
}
