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
    let imageNamePlane1 = "plane-1"
    let imageNamePlane2 = "plane-2"
    let lineWidht: CGFloat = 2
    let numberOfCircles: Int = 3
    let numberOfPlanes: Int = 65
    var dimentionPlane: CGFloat = 20
    let dimentionDelta: CGFloat = 2
    var escSq: Int = 8
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black
    
    var allRandomPlanesInArea = [[AKPlane]]()
    var radiusRadarArray: [CGFloat] = []
    var planeRadius: CGFloat = 0
    var neighbors: Int = 0
    var overlayPlane:Bool = false
    
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
        for _ in 0..<numberOfCircles {
            drawCircle(center: center, radius: radius)
            radiusRadarArray.append(radius)
            radius -= radiusDelta
            let randomPlanesInArea = [AKPlane] ()
            allRandomPlanesInArea.append(randomPlanesInArea)

        }
        
        dimentionPlane =  radiusDelta > dimentionPlane ? dimentionPlane : radiusDelta/2
        
        planeRadius = sqrt(2)/2 * dimentionPlane

        //MARK: - Generate Planes locations
        var i: Int = 1;
  
        while  (i <= numberOfPlanes) {
            
            let planeLocationX = CGFloat.random(in: 0..<frameSize)
            let planeLocationY = CGFloat.random(in: 0..<frameSize)
            let flag = checkPosition(x: planeLocationX, y: planeLocationY, center: center, delta: radiusDelta)

            if (flag) {
                let planeLocation = CGPoint (x: planeLocationX, y: planeLocationY)
                let planeSize = CGSize (width: dimentionPlane, height: dimentionPlane)
                let plane = CGRect (origin: planeLocation, size: planeSize)
    
                let randomColor = generateRandomColor()
                let planeColor = UIColor (red: randomColor.red, green: randomColor.green, blue: randomColor.blue, alpha: 1)
                drawRectangle(size: plane, color: planeColor.cgColor)
//                addImagesToSubview (location: plane)
                let avgNeighborsAtObject = neighbors / i
                if avgNeighborsAtObject >= escSq {
                    
                    print ("AVG: \(avgNeighborsAtObject) N planes:\(i)")
                    overlayPlane = true
                    
                }
                i += 1
            }
        }
    }

    func  generateRandomColor() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        return (red, green, blue )
    }
    
    func checkPosition(x: CGFloat, y: CGFloat, center: CGPoint, delta: CGFloat) -> Bool {
        
        var isInsideArea = false
        var radarBorderIn = CGFloat(0)
        let halfSize = dimentionPlane / 2.0
        let planeCenterX = x + halfSize
        let planeCenterY = y + halfSize
        let xDelta = planeCenterX - center.x
        let yDelta = planeCenterY - center.y
        let conditionRule = pow(xDelta,2) + pow(yDelta,2)
        let positionRadius = sqrt(conditionRule)
        var sector = Int (abs((radiusRadarArray[0] - positionRadius)) / delta)
        sector = (positionRadius != 0 ) ? sector :  radiusRadarArray.count - 1
        let indent = lineWidht + dimentionDelta
        let correctionOut = radiusRadarArray[sector] - planeRadius - indent
        let radarBorderOut  = pow(correctionOut,2)
        if (sector < radiusRadarArray.count - 1) {
            let correctionIn = radiusRadarArray[sector+1] + planeRadius + indent
            radarBorderIn  = pow(correctionIn,2)
        }

        if (radarBorderOut > conditionRule)&&( conditionRule >= radarBorderIn) {
            
            isInsideArea = checkIntersectsInArea(x: x, y: y, sector: sector, positionRadius: positionRadius, delta: delta)

        }
        return  isInsideArea
    }
    //MARK:  Check Intersections with saved objects
    func checkIntersectsInArea(x: CGFloat, y: CGFloat, sector: Int, positionRadius: CGFloat, delta: CGFloat) -> Bool {
        
        var isIntersectsInArea = false
        let genPlane = AKPlane ()
        genPlane.position = CGPoint (x: x, y: y)
        genPlane.size = CGSize (width: dimentionPlane, height: dimentionPlane)
        
        if (allRandomPlanesInArea[sector].count == 0) {
            
            allRandomPlanesInArea[sector].append(genPlane)
            isIntersectsInArea = true
            
            return isIntersectsInArea
            
        }else{
            
            for savedPlane:AKPlane in allRandomPlanesInArea[sector] {
                
                let generatedRect =  CGRect (origin: genPlane.position, size: genPlane.size)
                let savedRect = CGRect (origin: savedPlane.position, size: savedPlane.size)
                if (generatedRect.intersects(savedRect) && !overlayPlane) {
                    
                    isIntersectsInArea = false
                    
                    return isIntersectsInArea
                }
                    
                isIntersectsInArea = true
                    
                let nRect = CGRect (x: x-dimentionPlane, y: y-dimentionPlane, width: 3*dimentionPlane, height: 3*dimentionPlane)
                if nRect.intersects(savedRect) {
                    genPlane.neighbors += 1
                    savedPlane.neighbors += 1
                    neighbors += 1
                    
                }
            }
            
            if (positionRadius + 3*planeRadius) >= radiusRadarArray[sector] {
                genPlane.neighbors += 1
                neighbors += 1
            }
            if ((positionRadius - 3*planeRadius) <= radiusRadarArray[sector]-delta) {
                genPlane.neighbors += 1
                neighbors += 1
            }
        allRandomPlanesInArea[sector].append(genPlane)
        }
    return isIntersectsInArea
    }
    
    
    //MARK: Place Plane Images on subview
    func addImagesToSubview(location: CGRect){
   
        var planeImage:UIImageView?
        let image:UIImage = UIImage (named: imageNamePlane1)!
        planeImage = UIImageView(image: image)
        planeImage!.frame = location
        self.addSubview(planeImage!)
        
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
