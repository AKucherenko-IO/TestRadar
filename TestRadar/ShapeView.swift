//
//  ShapeView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

@IBDesignable


class ShapeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
    let lineWidht: CGFloat = 2
    
//    override init(frame: CGRect) {
//
//
//        super.init(frame: frame)
//
//        let screenWidth = UIScreen.main.bounds.width
//        let screenHeight =  UIScreen.main.bounds.height
//        print("width:\(screenWidth) height:\(screenHeight)")
//
//        let rectSize = screenWidth > screenHeight ? screenHeight : screenWidth
//        let viewRectX: CGFloat = 0;
//        let viewRectY: CGFloat = screenHeight/2.0 - rectSize/2.0
//
//
//        ShapeView.frame CGRect(x: viewRectX, y: viewRectY, width:rectSize, height:rectSize)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .red
    }
    
    override func draw(_ rect: CGRect) {
        
//        let currentShapeType: Int = 2
        let numberOfCircles: Int = 20
        

        
        let center = CGPoint(x: self.frame.size.width / 2.0, y:self.frame.size.height / 2.0)
        print ("Circle: center: \(center) frame: \(self.frame.size.width) \(self.frame.size.height)")
        var radius: CGFloat = center.x < center.y ? center.x - lineWidht : center.y - lineWidht
        let radiusDelta: CGFloat = radius / CGFloat(numberOfCircles)
//        switch currentShapeType {
//        case 0: drawLines()
//        case 1: drawRectangle()
//        case 2: drawCircle(center: center, radius: radius)
//        default: print("default")
        for i in 1...numberOfCircles {
            drawCircle(center: center, radius: radius)
            radius = radius - radiusDelta
        }
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
    
    func drawRectangle() {
//        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
//        let rectangleWidth:CGFloat = 100.0
//        let rectangleHeight:CGFloat = 100.0
//        let ctx = UIGraphicsGetCurrentContext()
//
//        //4
//        ctx?.addRect(CGRect(x: (center.x - (0.5 * rectangleWidth)), y: (center.y - (0.5 * rectangleHeight)), width: rectangleWidth, height: rectangleHeight))
//
//        ctx?.setLineWidth(10)
//        ctx?.setStrokeColor(red: 60, green: 30, blue: 50, alpha: 2)
//        ctx?.strokePath()
//
//        //5
//        ctx?.setFillColor(red: 100, green: 100, blue: 50, alpha: 1)
//        ctx?.addRect(CGRect(x: (center.x - (0.5 * rectangleWidth)), y: (center.y - (0.5 * rectangleHeight)), width: rectangleWidth, height: rectangleHeight))
//
//        ctx?.fillPath()
//
    }
    
    func drawCircle(center: CGPoint, radius: CGFloat) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        
        //6
        ctx?.setLineWidth(lineWidht)

        let endAngle: CGFloat = CGFloat(2 * Double.pi)
        ctx?.addArc(center: center, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx?.strokePath()
    }

}
