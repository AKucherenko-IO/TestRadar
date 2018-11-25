//
//  ShapeView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

//@IBDesignable

class ShapeView: UIView {

    
    //MARK: Define parameters
    let lineWidht: CGFloat = 2
    let numberOfCircles: Int = 4
    let numberOfPlanes: Int = 100
    let planeDimention: CGFloat = 10
    let dimentionDelta: CGFloat = 5
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black

    //MARK: - init View with param
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight =  UIScreen.main.bounds.height
        print("Screen: width:\(screenWidth) height:\(screenHeight)")

        let rectSize = screenWidth > screenHeight ? screenHeight : screenWidth
        let viewRectX: CGFloat = 0;
        let viewRectY: CGFloat = screenHeight/2.0 - rectSize/2.0

        self.frame = CGRect(x: viewRectX, y: viewRectY, width:rectSize, height:rectSize)
        
    }
    
    //MARK: Draw Radar
    override func draw(_ rect: CGRect) {
        
     

        let frameSize = self.frame.size.width
        let halfFrameSize = frameSize / 2.0
        let center = CGPoint(x: halfFrameSize, y:halfFrameSize)
        print ("Circle: center: \(center) frame: \(frameSize) \(frameSize)")
        var radius: CGFloat = halfFrameSize - lineWidht
        let radiusDelta: CGFloat = radius / CGFloat(numberOfCircles)
        
        //MARK: -  Generate Radar Circles
        for _ in 1...numberOfCircles {
            drawCircle(center: center, radius: radius)
            radius = radius - radiusDelta
        }
        
        let planeR = sqrt(2)/2 * planeDimention
        var i: Int = 1;
        
        //MARK: - Generate Planes location
        while  (i <= numberOfPlanes) {
            
            let planeLocationX = CGFloat.random(in: 0..<frameSize)
            let planeLocationY = CGFloat.random(in: 0..<frameSize)
            
            if (checkPosition(x: planeLocationX, y: planeLocationY, radius: 160, planeRadius: planeR , center: center)) {
                let randomColor = generateRandomColor()
                let planeColor = UIColor (red: randomColor.red, green: randomColor.green, blue: randomColor.blue, alpha: 1)
                let planeLocation = CGPoint (x: planeLocationX, y: planeLocationY)
                let planeSize = CGSize (width: planeDimention, height: planeDimention)
                let plane = CGRect (origin: planeLocation, size: planeSize)
                drawRectangle(size: plane, color: planeColor.cgColor)
                i = i + 1
            }
            
        }
    }
    
    func  generateRandomColor() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        return (red, green, blue )
    }
    
    func checkPosition(x: CGFloat, y: CGFloat, radius: CGFloat, planeRadius: CGFloat, center: CGPoint) -> Bool {
        
        var isInsideArea = false
        let halfSize = planeDimention / 2.0
        let planeCenterX = x + halfSize
        let planeCenterY = y + halfSize
        let xDelta = planeCenterX - center.x
        let yDelta = planeCenterY - center.y
        let correction = radius - planeRadius - lineWidht - dimentionDelta
        let radarBorder  = pow(correction,2)
        let conditionRule = pow(xDelta,2) + pow(yDelta,2)
        if (radarBorder > conditionRule ) {
            isInsideArea = true
            print ("\(radarBorder) > \(conditionRule) x:\(x) y:\(y) radius:\(radius) palane R:\(planeRadius) center:\(center)")
        }
        
        return  isInsideArea
    }
    
    func drawLines() {
//        //1
//        let ctx = UIGraphicsGetCurrentContext()
//
//        //2
//        (ctx ?? nil)!.beginPath()
//
//        ctx?.move(to: CGPoint(x:20.0, y:20.0))
//        ctx?.move(to: CGPoint(x:20.0, y:20.0))
//        ctx?.move(to: CGPoint(x:250.0, y:100.0))
//        ctx?.move(to: CGPoint(x:100.0, y:200.0))
//        ctx?.setLineWidth(lineWidht)
//
//        //3
//        ctx?.closePath()
//        ctx?.strokePath()
    }
    
    //MARK: Draw Plane
    func drawRectangle(size: CGRect, color: CGColor) {
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.addRect(size)

        ctx?.setLineWidth(lineWidht+2)
        ctx?.setStrokeColor(color)
        ctx?.strokePath()
//        ctx?.setFillColor(color)
//        ctx?.fillPath()
    }
    
    //MARK: - Draw Circle
    func drawCircle(center: CGPoint, radius: CGFloat) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        ctx?.addArc(center: center, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx?.setLineWidth(lineWidht)
        
        ctx?.setStrokeColor(cirlcleColor.cgColor)
        ctx?.strokePath()
        
    }

}
