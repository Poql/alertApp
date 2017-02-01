//
//  ServerValue + FIRServerValue.swift
//  Alert
//
//  Created by Gaétan Zanella on 01/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FIRServerValue: ServerValue {
    static var currentTime: Any {
        return timestamp()
    }
}
