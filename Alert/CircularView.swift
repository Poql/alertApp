//
//  CircularView.swift
//  Alert
//
//  Created by Gaétan Zanella on 04/03/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit

@IBDesignable class CircularView: UIView {

    var lineWidth: CGFloat = 2

    var fillColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    var strokeColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - UIView

    override func draw(_ rect: CGRect) {
        let origin = CGPoint(x: rect.origin.x + lineWidth / 2, y: rect.origin.y + lineWidth / 2)
        let size = CGSize(width: rect.width - lineWidth, height: rect.height - lineWidth)
        let rectangle = CGRect(origin: origin, size: size)
        let path = UIBezierPath(roundedRect: rectangle, cornerRadius: rect.width / 2)
        path.lineWidth = lineWidth
        fillColor.setFill()
        path.fill()
        strokeColor.setStroke()
        path.stroke()
    }
}
