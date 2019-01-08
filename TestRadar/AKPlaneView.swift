//
//  AKPlaneView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 09/12/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class AKPlaneView: UIView {

    // MARK: Define parameters
    var planeImageName = "plane-1"
    var planeLineWidht: CGFloat = 2
    let planeOrigin: CGPoint = CGPoint(x: 0, y: 0)
    var planeSize: CGSize = CGSize(width: 20, height: 20)
    var planeImageShow: Bool = true
    var planeRectShow: Bool = true
    let planeRectAlpha: CGFloat = 1

    // MARK: Draw PlaneView
    override func draw(_ rect: CGRect) {
        let plane = CGRect (origin: planeOrigin, size: planeSize)
        if planeRectShow {
          drawPlaneRectangle(size: plane)
        }
        if planeImageShow {
        addImagesToSubview (location: plane)
        }
    }

    func drawPlaneRectangle(size: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let rectColor = generateRandomColor()
        ctx?.addRect(size)
        ctx?.setLineWidth(planeLineWidht)
        ctx?.setStrokeColor(rectColor.cgColor)
        ctx?.strokePath()
    }

    func  generateRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: planeRectAlpha)
        return randomColor
    }

    // MARK: Place Plane Images to subview
    func addImagesToSubview(location: CGRect) {
        var planeImage: UIImageView?
        let image: UIImage = UIImage (named: planeImageName)!
        planeImage = UIImageView(image: image)
        planeImage!.frame = location
        self.addSubview(planeImage!)
    }

}
