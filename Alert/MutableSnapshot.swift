//
//  MutableSnapshot.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MutableSnapshot {
    var id: String? { get }
    var dictionary: [String : Any] { get set }
}
