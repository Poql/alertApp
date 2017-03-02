//
//  FIRDataSnapshot.swift
//  Alert
//
//  Created by Gaétan Zanella on 25/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FIRDataSnapshot {
    var childSnapshots: [FIRDataSnapshot] {
        return children.flatMap { $0 as? FIRDataSnapshot }
    }
}
