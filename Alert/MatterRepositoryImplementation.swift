//
//  MatterRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MatterRepositoryImplementation: FirebaseReferenceObserverRepository {
    fileprivate let matterMapper = MatterMapper()

    init() {
        super.init(baseReference: FIRDatabase.database().reference().child("matters"))
    }
}

// MARK: - MatterRepository

extension MatterRepositoryImplementation : MatterRepository {
    func observe(
        _ type: DataEventType,
        formId: String,
        with block: @escaping (_ matter: Matter, _ state: RecordState) -> Void) -> Int {
        return observe(pathString: formId, eventType: type) { (snapshot, state) in
            guard let matter = self.matterMapper.matter(from: snapshot) else { return }
            block(matter, state)
        }
    }

    func removeObserver(formId: String, handle: Int) {
        removeObserver(pathString: formId, handle: handle)
    }

    func insert(_ matter: MutableMatter, inFormWihIdentifier formId: String) {
        let id = UUID().uuidString
        let snapshot = matterMapper.snapshot(forNew: matter, identifier: id)
        setValue(snapshot.dictionary, atPath: "\(formId)/\(id)")
    }
}
