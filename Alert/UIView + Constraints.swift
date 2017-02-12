//
//  UIView + Constraints.swift
//  Alert
//
//  Created by Gaétan Zanella on 29/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIView {
    func gz_pinSubview(_ subview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero, edges: UIRectEdge = .all) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.bottom) {
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.right) {
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        }
    }
}
