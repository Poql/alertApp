//
//  CacheRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 23/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData

class CacheRepositoryImplementation: ObservableRepository<Alert> {

    fileprivate lazy var backgroundContext: NSManagedObjectContext = {
        return CoreDataStack.shared.newBackgroundContext()
    }()

    fileprivate var viewContext: NSManagedObjectContext {
        return CoreDataStack.shared.viewContext
    }

    // MARK: - Private methods

    fileprivate func update(alert: Alert, in backgroundContext: NSManagedObjectContext) {
        let request: NSFetchRequest<PersistentAlert> = PersistentAlert.fetchRequest()
        request.predicate = NSPredicate.entity(with: alert.id)
        do {
            let alerts = try request.execute()
            let persistentAlert: PersistentAlert
            if let currentAlert = alerts.first {
                PersistentAlertMapper.update(currentAlert, with: alert)
                persistentAlert = currentAlert
            } else {
                persistentAlert = PersistentAlertMapper.mapPersistentAlert(from: alert, in: backgroundContext)
            }
            self.notifyObserver(.updated, persistentAlert: persistentAlert)
            try backgroundContext.save()
        }
        catch {}
    }

    fileprivate func remove(alert: Alert, in backgroundContext: NSManagedObjectContext) {
        let request: NSFetchRequest<PersistentAlert> = PersistentAlert.fetchRequest()
        request.predicate = NSPredicate.entity(with: alert.id)
        do {
            guard let alert = try request.execute().first else { return }
            backgroundContext.delete(alert)
            self.notifyObserver(.removed, persistentAlert: alert)
            try backgroundContext.save()
        }
        catch {}
    }

    fileprivate func fetchCurrentAlerts(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<PersistentAlert> = PersistentAlert.fetchRequest()
        do {
            let alerts = try request.execute() 
            for alert in alerts {
                self.notifyObserver(.added, persistentAlert: alert)
            }
        }
        catch {}
    }

    fileprivate func notifyObserver(_ type: DataEventType, persistentAlert: PersistentAlert) {
        guard let alert = PersistentAlertMapper.mapAlert(from: persistentAlert) else { return }
        DispatchQueue.main.async {
            self.notifyObservers(type, for: alert)
        }
    }
}

// MARK: - CacheRepository

extension CacheRepositoryImplementation: CacheRepository {

    func observe(_ type: DataEventType, with block: @escaping (Alert) -> Void) -> Int {
        let handle = attachObserver(type, with: block)
        viewContext.perform {
            self.fetchCurrentAlerts(in: self.viewContext)
        }
        return handle
    }

    func removeObserver(withHandle handle: Int) {
        removeAttachedObserver(withHandle: handle)
    }

    func update(alert: Alert) {
        backgroundContext.perform {
            self.update(alert: alert, in: self.backgroundContext)
        }
    }

    func remove(alert: Alert) {
        backgroundContext.perform {
            self.remove(alert: alert, in: self.backgroundContext)
        }
    }
}
