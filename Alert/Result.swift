//
//  Result.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation


enum Result<T, E: Error> {
    case value(T)
    case error(E)

    init?(value: T?, error: E?) {
        if let value = value {
            self = .value(value)
        } else if let error = error {
            self = .error(error)
        } else {
            return nil
        }
    }
}
