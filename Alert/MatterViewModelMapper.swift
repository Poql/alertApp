//
//  MatterViewModelMapper.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct MatterViewModelMapper {
    func viewModel(from matter: Matter, isCommited: Bool) -> MatterViewModel {
        return MatterViewModel(id: matter.id, name: matter.name, isInteractive: isCommited)
    }
}
