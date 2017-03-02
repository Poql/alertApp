//
//  FirebaseReferenceObserverRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 01/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias FirebaseObservationBlock = (FIRDataSnapshot, RecordState) -> Void

class FirebaseReferenceObserverRepository {

    private var pendingChildrenIds: Set<String> = []

    private var observedValues: [String : FIRDataSnapshot] = [:]

    private let observersDwelling = ObserversDwelling<FIRDataSnapshot>()

    private let baseReference: FIRDatabaseReference

    // MARK: - Life Cycle

    init(baseReference: FIRDatabaseReference) {
        self.baseReference = baseReference
    }

    // MARK: - Public

    func observe(pathString: String, eventType: DataEventType, with block: @escaping FirebaseObservationBlock) -> Int {
        let handle = baseReference.child(pathString).observe(eventType.firebaseType, with: { snapshot in
            self.observersDwelling.notifyObservers(eventType, for: snapshot)
        })
        return observersDwelling.attachObserver(eventType, handle: Int(handle)) { snapshot in
            self.observationBlockProxy(eventType, snapshot: snapshot, block: block)
        }
    }

    func removeObserver(pathString: String, handle: Int) {
        observersDwelling.removeAttachedObserver(withHandle: handle)
        baseReference.child(pathString).removeObserver(withHandle: UInt(handle))
    }

    func removeAllObservers() {
        observersDwelling.currentHandles.forEach { baseReference.removeObserver(withHandle: UInt($0)) }
        observersDwelling.removeAllObservers()
    }

    func setValue(_ value: Any?, atPath path: String) {
        let reference = baseReference.child(path)
        guard !pendingChildrenIds.contains(reference.url) else { return }
        pendingChildrenIds.insert(reference.url)
        reference.setValue(value, withCompletionBlock: setValueCompletionBlock)
    }

    // MARK: - Private

    private func observationBlockProxy(_ type: DataEventType, snapshot: FIRDataSnapshot, block: FirebaseObservationBlock) {
        let state: RecordState = pendingChildrenIds.contains(snapshot.ref.url) ? .pending : .commited
        switch type {
        case .removed:
            observedValues.removeValue(forKey: snapshot.ref.url)
        case .updated, .added:
            observedValues[snapshot.ref.url] = snapshot
        }
        block(snapshot, state)
    }

    private func setValueCompletionBlock(error: Error?, reference: FIRDatabaseReference) {
        pendingChildrenIds.remove(reference.url)
        guard let snapshot = self.observedValues[reference.url] else { return }
        if error != nil {
            observersDwelling.notifyObservers(.removed, for: snapshot)
            return
        }
        observersDwelling.notifyObservers(.added, for: snapshot)
    }
}
