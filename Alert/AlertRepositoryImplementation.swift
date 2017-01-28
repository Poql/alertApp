//
//  AlertRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 24/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AlertRepositoryImplementation {
    fileprivate lazy var databaseReference = FIRDatabase.database().reference()
    fileprivate var alertReference: FIRDatabaseReference {
        return databaseReference.child("alerts")
    }
}

// MARK: - AlertRepository

extension AlertRepositoryImplementation: AlertRepository {
    func observe(_ type: DataEventType, with block: @escaping (Alert) -> Void) -> Int {
        let handle = alertReference.observe(type.firebaseType, with: { snapshot in
            guard let alert = AlertMapper.mapAlert(from: snapshot) else { return }
            block(alert)
        })
        return Int(handle)
    }

    func removeObserver(withHandle handle: Int) {
        guard handle >= 0 else { return }
        alertReference.removeObserver(withHandle: UInt(handle))
    }

    func create(newAlert alert: Alert) {
        let child = alertReference.childByAutoId()
        let snapshot = AlertMapper.snapshot(forNewAlert: alert, with: child.key)
        child.setValue(snapshot)
    }
}

