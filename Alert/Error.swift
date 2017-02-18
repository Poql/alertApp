//
//  Error.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation


enum ApplicationError: Error {
    case generic

    var title: String {
        switch self {
        case .generic:
            return "generic_error_title".localized
        }
    }

    var message: String {
        switch self {
        case .generic:
            return "generic_error_message".localized
        }
    }
}

enum ServerError: Error {
    case generic
}
