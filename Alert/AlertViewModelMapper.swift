//
//  AlertViewModelMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct AlertViewModelMapper {
    static func alertViewModel(from alert: Alert) -> AlertViewModel {
        return AlertViewModel(id: alert.id, description: alert.description)
    }
}
