//
//  UIColor.swift
//  Alert
//
//  Created by Gaétan Zanella on 11/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }

    class var gz_darkRed: UIColor {
        return UIColor(red: 208, green: 2, blue: 27)
    }

    class var gz_gray: UIColor {
        return UIColor(red: 74, green: 74, blue: 74)
    }
}

