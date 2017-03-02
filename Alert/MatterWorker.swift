//
//  MatterWorker.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MatterWorker {
    func beginSynchronisation()
    func stopSynchronisation()
    func addMatter(_ matter: MutableMatter)
}

protocol MatterViewContract: class {
    func add(_ matter: MatterViewModel)
    func update(_ matter: MatterViewModel)
    func handleError(_ error: ApplicationError)
}
