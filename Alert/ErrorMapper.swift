//
//  ErrorMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct ErrorMapper {
    static func applicationError(from error: ServerError) -> ApplicationError {
        switch error {
        case .generic:
            return .generic
        }
    }
}
