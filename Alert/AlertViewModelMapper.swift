//
//  AlertViewModelMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct AlertViewModelMapper {

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter
    }()

    func alertViewModel(from alert: Alert) -> AlertViewModel {
        return AlertViewModel(
            id: alert.id,
            description: alert.description,
            matterName: alert.matterName,
            creationDate: dateFormatter.string(from: alert.creationDate),
            triggerDate: dateFormatter.string(from: alert.triggerDate),
            disclaimsCount: alert.disclaimers.count,
            approvalsCount: alert.approvers.count
        )
    }
}
