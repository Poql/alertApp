//
//  SegueHandler.swift
//  Alert
//
//  Created by Gaétan Zanella on 05/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    func segueIdentifier(from segue: UIStoryboardSegue) -> SegueIdentifier? {
        return segue.identifier.flatMap { SegueIdentifier(rawValue: $0) }
    }

    func performSegue(with identifier: SegueIdentifier, sender: Any?) {
        let id = identifier.rawValue
        performSegue(withIdentifier: id, sender: sender)
    }
}
