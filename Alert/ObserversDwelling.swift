//
//  ObservableRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 24/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

class ObserversDwelling<T> {

    private var blocks: [Int : (T) -> Void] = [:]

    private var handles: [DataEventType : Set<Int>]  = [:]

    var currentHandles: [Int] {
        return Array(handles.values).flatMap { $0 }
    }

    // MARK: - Public

    func removeAllObservers() {
        blocks = [:]
        handles = [:]
    }

    func attachObserver(_ type: DataEventType, handle: Int? = nil, with block:  @escaping (T) -> Void) -> Int {
        let id = handle ?? UUID().hashValue
        blocks[id] = block
        var types = handles[type] ?? Set()
        types.insert(id)
        handles[type] = types
        return id
    }

    func removeAttachedObserver(withHandle handle: Int) {
        blocks.removeValue(forKey: handle)
        for (type, ids) in handles {
            var newIds = ids
            newIds.remove(handle)
            handles[type] = newIds
        }
    }

    func notifyObservers(_ type: DataEventType, for data: T) {
        let ids = handles[type] ?? []
        for id in ids {
            blocks[id]?(data)
        }
    }
}
