//
//  CollectionView + RegistrableCell.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol IdentifiedCell: class {
    static var identifier: String { get }
}

enum RegistrableView<T: IdentifiedCell> {
    case fromNib(T.Type)
    case fromClass(T.Type)
}

extension UITableView {
    func register<T: IdentifiedCell>(cell: RegistrableView<T>) {
        switch cell {
        case let .fromNib(cell):
            let identifier = cell.identifier
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        case let .fromClass(cell):
            let identifier = cell.identifier
            register(cell, forCellReuseIdentifier: identifier)
        }
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

extension IdentifiedCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifiedCell {}
