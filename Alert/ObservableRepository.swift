//
//  ObservableRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 24/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

class ObservableRepository<T> {

    private var blocks: [Int : (T) -> Void] = [:]

    private var handles: [DataEventType : Set<Int>]  = [:]

    // MARK: - Public

    final func attachObserver(_ type: DataEventType, with block:  @escaping (T) -> Void) -> Int {
        let id = UUID().hashValue
        blocks[id] = block
        var types = handles[type] ?? Set()
        types.insert(id)
        handles[type] = types
        return id
    }

    final func removeAttachedObserver(withHandle handle: Int) {
        blocks.removeValue(forKey: handle)
        for (type, ids) in handles {
            var newIds = ids
            newIds.remove(handle)
            handles[type] = newIds
        }
    }

    final func notifyObservers(_ type: DataEventType, for data: T) {
        let ids = handles[type] ?? []
        for id in ids {
            blocks[id]?(data)
        }
    }
}
