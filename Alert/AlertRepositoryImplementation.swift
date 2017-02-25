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
    fileprivate lazy var  alertMapper = AlertMapper(serverValue: FIRServerValue.self)
    fileprivate var alertReference: FIRDatabaseReference {
        return databaseReference.child("alerts")
    }
}

// MARK: - AlertRepository

extension AlertRepositoryImplementation: AlertRepository {
    func insert(alert: MutableAlert, formId: String) {
        let reference = alertReference.child(formId).childByAutoId()
        let snapshot = alertMapper.snapshot(forNewAlert: alert, identifier: reference.key, formId: formId)
        reference.setValue(snapshot.dictionary)
    }

    func observe(_ type: DataEventType, formId: String, with block: @escaping (Alert) -> Void) -> Int {
        let handle = alertReference.child(formId).observe(type.firebaseType, with: { snapshot in
            guard let alert = self.alertMapper.mapAlert(from: snapshot) else { return }
            block(alert)
        })
        return Int(handle)
    }

    func removeObserver(withHandle handle: Int) {
        guard handle >= 0 else { return }
        alertReference.removeObserver(withHandle: UInt(handle))
    }

    func deprecateAlert(alertId: String, formId: String, user: User) {
        alertReference.child(formId).child(alertId).runTransactionBlock { snapshot in
            let newSnaphot = self.alertMapper.snapshot(forDeprecatedAlert: snapshot, by: user)
            return FIRTransactionResult.success(withValue: newSnaphot)
        }
    }

    func approveAlert(alertId: String, formId: String, user: User) {
        alertReference.child(formId).child(alertId).runTransactionBlock { snapshot in
            let newSnaphot = self.alertMapper.snapshot(forApprovedAlert: snapshot, by: user)
            return FIRTransactionResult.success(withValue: newSnaphot)
        }
    }
}

