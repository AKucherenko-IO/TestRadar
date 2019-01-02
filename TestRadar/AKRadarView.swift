//
//  AKRadarView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

@IBDesignable

class AKRadarView: UIView {

    // MARK: Define parameters
    var radarLevelLineWidht: CGFloat = 2
    var radarLevelNumber: Int = 2
    var radarLevelBorderColor: UIColor = UIColor.black
    var radarLevelFillColor: UIColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.1)
    var radarLevelDelta: CGFloat = 0.0
    var radarLevelRadius: CGFloat = 0.0
    var radarCenter: CGPoint = CGPoint(x: 0, y: 0)

    // MARK: Draw Radar
    override func draw(_ rect: CGRect) {
        // MARK: - Generate Radar Circles and svae innerArea for planes
        for _ in 0..<radarLevelNumber {
            drawCircle(center: radarCenter, radius: radarLevelRadius)
            radarLevelRadius -= radarLevelDelta
        }
    }

    // MARK: - Draw Circle
    func drawCircle(center: CGPoint, radius: CGFloat) {
        let circleRectSize = 2 * radius
        let circleRectX = center.x - radius
        let circleRectY = center.y - radius
        let circleRect = CGRect(x: circleRectX, y: circleRectY, width: circleRectSize, height: circleRectSize)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        ctx?.addArc(center: center, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx?.setLineWidth(radarLevelLineWidht)
        ctx?.setStrokeColor(radarLevelBorderColor.cgColor)
        ctx?.setFillColor(radarLevelFillColor.cgColor)
        ctx?.strokePath()
        ctx?.fillEllipse(in: circleRect)
    }

}
