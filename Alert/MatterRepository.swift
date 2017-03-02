//
//  MatterRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MatterRepository {
    func observe(
        _ type: DataEventType,
        formId: String,
        with block: @escaping (_ matter: Matter, _ state: RecordState) -> Void) -> Int
    func removeObserver(formId: String, handle: Int)
    func insert(_ matter: MutableMatter, inFormWihIdentifier formId: String)
}
