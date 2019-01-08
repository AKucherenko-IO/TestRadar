//
//  AKRadarView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class AKRadarView: UIView {

    // MARK: Define parameters
    var radarLevelsLineWidht: CGFloat = 2
    var radarLevelsNumber: Int = 2
    var radarLevelsBorderColor: UIColor = UIColor.black
    var radarLevelsFillColor: UIColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.1)
    var radarLevelsDelta: CGFloat = 0.0
    var radarLevelsRadius: CGFloat = 0.0
    var radarCenter: CGPoint = CGPoint(x: 0, y: 0)

    // MARK: Draw RadarView
    override func draw(_ rect: CGRect) {
        // MARK: - Generate RadarView Levels
        for _ in 0..<radarLevelsNumber {
            drawCircle(center: radarCenter, radius: radarLevelsRadius)
            radarLevelsRadius -= radarLevelsDelta
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
        ctx?.setLineWidth(radarLevelsLineWidht)
        ctx?.setStrokeColor(radarLevelsBorderColor.cgColor)
        ctx?.setFillColor(radarLevelsFillColor.cgColor)
        ctx?.strokePath()
        ctx?.fillEllipse(in: circleRect)
    }

}
