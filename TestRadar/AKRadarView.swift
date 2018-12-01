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
    let numberOfCircles: Int = 3
    let numberOfPlanes: Int = 20
    var dimensionPlane: CGFloat = 20
    let dimensionDelta: CGFloat = 5
    var availablePositions: Int = 8
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black
    
    var allRandomPlanesInArea = [[AKPlane]]()
    var radiusRadarArray: [CGFloat] = []
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
        
        dimensionPlane = radiusDelta > dimensionPlane ? dimensionPlane : radiusDelta/2
        
        planeRadius = sqrt(2)/2 * dimensionPlane

        //MARK: - Generate Planes locations
        var i: Int = 1;
  
        while  (i <= numberOfPlanes) {
            
            let planePositionX = CGFloat.random(in: 0..<frameSize)
            let planePositionY = CGFloat.random(in: 0..<frameSize)
            let flag = checkPosition(x: planePositionX, y: planePositionY, center: center, delta: radiusDelta)
            
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

    
    func checkPosition(x: CGFloat, y: CGFloat, center: CGPoint, delta: CGFloat) -> Bool {
        
        var isInsideArea = false
        var radarBorderIn = CGFloat(0)
        let halfSize = dimensionPlane / 2.0
        let planeCenterX = x + halfSize
        let planeCenterY = y + halfSize
        let xDelta = planeCenterX - center.x
        let yDelta = planeCenterY - center.y
        let conditionRule = pow(xDelta,2) + pow(yDelta,2)
        let positionRadius = sqrt(conditionRule)
        var sector = Int (abs((radiusRadarArray[0] - positionRadius)) / delta)
        
        sector = (positionRadius != 0 ) ? sector :  radiusRadarArray.count - 1
        
        let indent = lineWidht + dimensionDelta
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
            
            if (positionRadius + 3*planeRadius) >= radiusRadarArray[sector] {
                randomPlane.neighbors += 1
                neighbors += 1
            }
            if ((positionRadius - 3*planeRadius) <= radiusRadarArray[sector]-delta) {
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
