//
//  AKRadarView.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

//@IBDesignable

class AKRadarView: UIView {

    //MARK: Define parameters
    let imageNamePlane1 = "plane-1"
    let lineWidht: CGFloat = 2
    let numberOfCircles: Int = 2
    let numberOfPlanes: Int = 100
    var dimensionPlane: CGFloat = 20
    let dimensionDelta: CGFloat = 5
    var availablePositions: Int = 8
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black
    
    var allRandomPlanesInArea = [[AKPlane]]()
    var inerAreaArray: [(CGFloat, CGFloat)] = []
    var planeRadius: CGFloat = 0
    var neighbors: Int = 0
    var isOverlayPlane:Bool = false
    
    //MARK: - init View with param
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight =  UIScreen.main.bounds.height
        print ("Screen size: width=\(screenWidth)\theight:\(screenHeight)")
        let rectSize = screenWidth > screenHeight ? screenHeight : screenWidth
        let viewRectX: CGFloat = 0;
        let viewRectY: CGFloat = screenHeight/2.0 - rectSize/2.0
        print ("viewY: \(viewRectY) = \(screenHeight)/2 -\(rectSize)/2")
        self.frame = CGRect(x: viewRectX, y: viewRectY, width:rectSize, height:rectSize)
        
    }
    
    //MARK: Draw Radar
    override func draw(_ rect: CGRect) {
        
        let frameSize = self.frame.size.width
        let halfFrameSize = frameSize / 2.0
        let center = CGPoint(x: halfFrameSize, y:halfFrameSize)
        var radius: CGFloat = halfFrameSize - lineWidht
        let radiusDelta: CGFloat = radius / CGFloat(numberOfCircles)
        planeRadius = sqrt(2)/2 * dimensionPlane
        
        let inerAreaSize = radiusDelta - (2 * planeRadius)
        dimensionPlane = radiusDelta > dimensionPlane ? dimensionPlane : radiusDelta/2
        //MARK: Check Center
        print ("Frame Size: \(frameSize) \t \(halfFrameSize)")
        print("Center: \(center)\tareaSize:\(inerAreaSize)")
        
        
        //MARK: -  Generate Radar Circles and svae innerArea for planes
        for _ in 0..<numberOfCircles {
            
            drawCircle(center: center, radius: radius)
            let externalRadius = radius - planeRadius
            radius -= radiusDelta
            let internalRadius = radius != 0 ? radius + planeRadius : 0
            let inerArea = (externalRadius,internalRadius)
            let randomPlanesInArea = [AKPlane] ()
            inerAreaArray.append(inerArea)
            allRandomPlanesInArea.append(randomPlanesInArea)

        }


        //MARK: - Generate Planes locations
        var i: Int = 1;
  
        while  (i <= numberOfPlanes) {
            let randomDeltaRadius = CGFloat.random(in: 0..<inerAreaSize)
//                CGFloat(0)
//                CGFloat.random(in: 0..<inerAreaSize)
            if (randomDeltaRadius == 0) {
                print ("randomDeltaRadius:\(randomDeltaRadius)")
            }
            let randomCircle = Int.random(in: 0..<numberOfCircles)
            let randomAngle = Double.random(in: 0...360)
            let randomRadius =  Double(randomDeltaRadius + inerAreaArray[randomCircle].1)
            let planePositionX = center.x + CGFloat(randomRadius * sin(randomAngle)) - dimensionPlane / 2
            let planePositionY = center.y + CGFloat(randomRadius * cos(randomAngle)) - dimensionPlane / 2
//            print ("Param: randomCircle:\(randomCircle)\trandomDeltaRadius:\(randomDeltaRadius)\trandomAngle:\(randomAngle)\trandomRadius:\(randomRadius)  " )
//            let flag = checkPosition(x: planePositionX, y: planePositionY, center: center, delta: radiusDelta)
            let flag = checkIntersectsInArea(x: planePositionX, y: planePositionY, sector: randomCircle, positionRadius: CGFloat(randomRadius), delta: inerAreaSize)
            
            if (flag) {
                
                let planeLocation = CGPoint (x: planePositionX, y: planePositionY)
                let planeSize = CGSize (width: dimensionPlane, height: dimensionPlane)
                let plane = CGRect (origin: planeLocation, size: planeSize)
    
                addImagesToSubview (location: plane)
                let avgNeighborsAtObject = neighbors / i
                
                if avgNeighborsAtObject >= availablePositions {
                    
                    isOverlayPlane = true
                    
                }
            
                i += 1
        
            }
        
        }
        
    }

    
//    func checkPosition(x: CGFloat, y: CGFloat, center: CGPoint, delta: CGFloat) -> Bool {
//        
//        var isInsideArea = false
//        var radarBorderIn = CGFloat(0)
//        let halfSize = dimensionPlane / 2.0
//        let planeCenterX = x + halfSize
//        let planeCenterY = y + halfSize
//        let xDelta = planeCenterX - center.x
//        let yDelta = planeCenterY - center.y
//        let conditionRule = pow(xDelta,2) + pow(yDelta,2)
//        let positionRadius = sqrt(conditionRule)
//        var sector = Int (abs((inerAreaArray[0] - positionRadius)) / delta)
//
//        sector = (positionRadius != 0 ) ? sector :  radiusRadarArray.count - 1
//
//        let indent = lineWidht + dimensionDelta
//        let correctionOut = radiusRadarArray[sector] - planeRadius - indent
//        let radarBorderOut  = pow(correctionOut,2)
//
//        if (sector < radiusRadarArray.count - 1) {
//
//            let correctionIn = radiusRadarArray[sector+1] + planeRadius + indent
//            radarBorderIn  = pow(correctionIn,2)
//
//        }

//        if (radarBorderOut > conditionRule)&&( conditionRule >= radarBorderIn) {
//
//            isInsideArea = checkIntersectsInArea(x: x, y: y, sector: sector, positionRadius: positionRadius, delta: delta)
//
//        }
//
//        return  isInsideArea
//
//    }
    //MARK:  Check Intersections with saved objects
    func checkIntersectsInArea(x: CGFloat, y: CGFloat, sector: Int, positionRadius: CGFloat, delta: CGFloat) -> Bool {
        
        var notIntersectsInArea = false
        let randomPlane = AKPlane ()
        randomPlane.position = CGPoint (x: x, y: y)
        randomPlane.size = CGSize (width: dimensionPlane, height: dimensionPlane)
        
        if (allRandomPlanesInArea[sector].count == 0) {
            
            allRandomPlanesInArea[sector].append(randomPlane)
            notIntersectsInArea = true
            
            return notIntersectsInArea
            
        }else{
            
            for savedPlane:AKPlane in allRandomPlanesInArea[sector] {
                
                let generatedRect =  CGRect (origin: randomPlane.position, size: randomPlane.size)
                let savedRect = CGRect (origin: savedPlane.position, size: savedPlane.size)
            
                if (generatedRect.intersects(savedRect) && !isOverlayPlane) {
                    
                    notIntersectsInArea = false
                    
                    return notIntersectsInArea
                }
                    
                notIntersectsInArea = true
                    
                let overSizePlane = CGRect (x: x-dimensionPlane, y: y-dimensionPlane, width: 3*dimensionPlane, height: 3*dimensionPlane)
                
                if overSizePlane.intersects(savedRect) {
                    randomPlane.neighbors += 1
                    savedPlane.neighbors += 1
                    neighbors += 1
                    
                }
            }
            
            if (positionRadius + 2*planeRadius) >= inerAreaArray[sector].0 {
                randomPlane.neighbors += 1
                neighbors += 1
            }
            if ((positionRadius - 2*planeRadius) <= inerAreaArray[sector].1) {
                randomPlane.neighbors += 1
                neighbors += 1
            }
        
            allRandomPlanesInArea[sector].append(randomPlane)
        
        }
        
    return notIntersectsInArea
        
    }
    
    //MARK: Place Plane Images on subview
    func addImagesToSubview(location: CGRect){
   
        var planeImage:UIImageView?
        let image:UIImage = UIImage (named: imageNamePlane1)!
        planeImage = UIImageView(image: image)
        planeImage!.frame = location
        self.addSubview(planeImage!)
        
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
