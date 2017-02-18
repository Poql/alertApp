//
//  UserSnapshot.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol UserSnapshot {
    var id: String { get }
    var name: String? { get }
    var email: String? { get }
}
