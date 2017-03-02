//
//  MatterViewModel.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct MatterViewModel {
    let id: String
    let name: String
    let isInteractive: Bool
}

// MARK: - IdentifiableEntity

extension MatterViewModel : IdentifiableEntity, Hashable {}

