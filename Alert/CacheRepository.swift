//
//  CacheRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData

protocol CacheRepository {
    func purgeCache()
    func update(alert: Alert)
    func remove(alert: Alert)
    func fetchCurrentCache(completion: @escaping ([Alert]) -> Void)
    func observe(_ type: DataEventType, with block: @escaping (Alert) -> Void) -> Int
    func removeObserver(withHandle handle: Int)
}
