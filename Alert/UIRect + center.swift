//
//  UIRect + center.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
        }
        set {
            origin.x = newValue.x - width / 2
            origin.y = newValue.y - height / 2
        }
    }
}
