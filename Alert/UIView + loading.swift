//
//  UIView + loading.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIView {
    static func fromNib<T: UIView>() -> T {
        let name = String(describing: T.self)
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! T
    }
}
