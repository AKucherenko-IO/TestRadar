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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
    let lineWidht: CGFloat = 2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight =  UIScreen.main.bounds.height
        print("width:\(screenWidth) height:\(screenHeight)")

        let rectSize = screenWidth > screenHeight ? screenHeight : screenWidth
        let viewRectX: CGFloat = 0;
        let viewRectY: CGFloat = screenHeight/2.0 - rectSize/2.0

        self.frame = CGRect(x: viewRectX, y: viewRectY, width:rectSize, height:rectSize)
 
        
    }
    
    override func draw(_ rect: CGRect) {
        

        let numberOfCircles: Int = 10
        let numberOfPlanes: Int = 10
        let planeDimention: CGFloat = 5
        let cirlcleColog: UIColor = UIColor.green

        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        let center = CGPoint(x: screenWidth / 2.0, y:screenHeight / 2.0)
        print ("Circle: center: \(center) frame: \(self.frame.size.width) \(self.frame.size.height)")
        var radius: CGFloat = center.x < center.y ? center.x - lineWidht : center.y - lineWidht
        let radiusDelta: CGFloat = radius / CGFloat(numberOfCircles)

        for _ in 1...numberOfCircles {
            drawCircle(center: center, radius: radius, color: cirlcleColog.cgColor)
            radius = radius - radiusDelta
        }
        var i: Int = 1;
        let radarBorder  = powf(160,2)
      while  (i <= numberOfPlanes) {
            let planeLocationX = CGFloat.random(in: 0..<screenWidth)
            let planeLocationY = CGFloat.random(in: 0..<screenHeight)
        
            let conditionRule = Float(pow(planeLocationX-center.x,2) + pow(planeLocationY-center.y,2))
        if (radarBorder >  conditionRule) {
            let red = CGFloat.random(in: 0...1.0)
            let green = CGFloat.random(in: 0...1.0)
            let blue = CGFloat.random(in: 0...1.0)
            let planeColor = UIColor (red: red, green: green, blue: blue, alpha: 1)
            let planeLocation = CGPoint (x: planeLocationX, y: planeLocationY)
            let planeSize = CGSize (width: planeDimention, height: planeDimention)
            let plane = CGRect (origin: planeLocation, size: planeSize)
            drawRectangle(size: plane, color: planeColor.cgColor)
            i = i + 1
        }
        }
    }
    func checkPosition(){
        
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
    
    func drawRectangle(size: CGRect, color: CGColor) {
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.addRect(size)

        ctx?.setLineWidth(lineWidht+2)
        ctx?.setStrokeColor(color)
        ctx?.strokePath()
        ctx?.setFillColor(color)
        ctx?.fillPath()
    }
    
    func drawCircle(center: CGPoint, radius: CGFloat, color: CGColor) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        ctx?.addArc(center: center, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx?.setLineWidth(lineWidht)
        
        ctx?.setStrokeColor(color)
        ctx?.strokePath()
        
        ctx?.setFillColor(color)
        ctx?.fillPath()
    }

}
