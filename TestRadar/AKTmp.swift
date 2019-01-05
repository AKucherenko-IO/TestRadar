//
//  AKTmp.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 11/12/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

// swiftlint:disable all

class AKTmp: UIView {
    
    //MARK: Define parameters
    let imageNamePlane1 = "plane-1"
    let lineWidht: CGFloat = 2
    let numberOfCircles: Int = 2
    let numberOfPlanes: Int = 10
    var dimensionPlane: CGFloat = 10
    let dimensionDelta: CGFloat = 2
    var availablePositions: Int = 8
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black
    
    var allRandomPlanesInArea = [[AKPlane]]()
    var inerAreaArray: [(CGFloat, CGFloat)] = []
    var planeRadius: CGFloat = 0
    var neighbors: Int = 0
    var isOverlayPlane:Bool = false
    
    
    //MARK: Draw Radar
    override func draw(_ rect: CGRect) {
        
        let lineWidhtCorrection = 2*lineWidht
        let frameSize: CGFloat = self.frame.size.width
        let halfFrameSize = frameSize / 2.0
        let center = CGPoint(x: halfFrameSize, y:halfFrameSize)
        var radius: CGFloat = halfFrameSize - lineWidhtCorrection
        let radiusDelta: CGFloat = radius / CGFloat(numberOfCircles)
        dimensionPlane = (radiusDelta - dimensionPlane - lineWidhtCorrection-1) > 0 ? dimensionPlane : (radiusDelta - lineWidhtCorrection-1)/2
        planeRadius = sqrt(2)/2 * dimensionPlane
        
        let inerAreaSize = radiusDelta - (2 * planeRadius) - lineWidhtCorrection
        availablePositions = Int (round(radiusDelta / dimensionPlane ) )
        availablePositions = availablePositions < 4 ? 4 : availablePositions
        print ("availablePositions:\(availablePositions) (\(radiusDelta)/\(dimensionPlane))")
        
        //MARK: Check Center
        print ("Frame Size: \(frameSize) \t \(halfFrameSize)")
        print("Center: \(center)\tareaSize:\(inerAreaSize) \(dimensionPlane) \(radiusDelta)")
        
        
        //MARK: -  Generate Radar Circles and svae innerArea for planes
        for _ in 0..<numberOfCircles {
            
            drawCircle(center: center, radius: radius)
            let externalRadius = radius - planeRadius - dimensionDelta
            let internalRadius = radius != 0 ? externalRadius - inerAreaSize : 0
            let inerArea = (externalRadius,internalRadius)
            let randomPlanesInArea = [AKPlane] ()
            inerAreaArray.append(inerArea)
            allRandomPlanesInArea.append(randomPlanesInArea)
            radius -= radiusDelta
            
        }
        
        //MARK: - Generate Planes locations
        var i: Int = 1;
        
        while  (i <= numberOfPlanes) {
            let randomDeltaRadius = CGFloat.random(in: 0..<inerAreaSize)
            
            let randomCircle = Int.random(in: 0..<numberOfCircles)
            let randomAngle = Double.random(in: 0...360)
            let randomRadius =  Double(randomDeltaRadius + inerAreaArray[randomCircle].1)
            let planePositionX = center.x + CGFloat(randomRadius * sin(randomAngle)) - dimensionPlane / 2
            let planePositionY = center.y + CGFloat(randomRadius * cos(randomAngle)) - dimensionPlane / 2
            
            let randomPlane = AKPlane ()
            randomPlane.position = CGPoint (x: planePositionX, y: planePositionY)
            randomPlane.size = CGSize (width: dimensionPlane, height: dimensionPlane)
            
            let flag = checkIntersectsInArea(planePosition: randomPlane.position, planeSize: randomPlane.size, sector: randomCircle, positionRadius: CGFloat(randomRadius) )
            
            if (flag) {
                
                let avgNeighborsAtObject = neighbors / i
                print ("\(avgNeighborsAtObject)")
                
                if avgNeighborsAtObject >= availablePositions {
                    print ("AVG N:\(avgNeighborsAtObject)\t NeiArray:\(neighbors)::\tAvailable:\(availablePositions)\ti:\(i)")
                    isOverlayPlane = true
                    i = numberOfPlanes + 1
                    
                }
                
                i += 1
                
                countNeighbors (planePosition: randomPlane.position, planeSize: randomPlane.size, sector: randomCircle, positionRadius: CGFloat(randomRadius), delta: inerAreaSize)
                
                let plane = CGRect (origin: randomPlane.position, size: randomPlane.size)
                drawRectangle(size: plane)
                //                addImagesToSubview (location: plane)
                allRandomPlanesInArea[randomCircle].append(randomPlane)
                
                
            }
            
        }
        
    }
    
    //MARK: Draw Plane
    func drawRectangle(size: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let componentColor = generateRandomColor()
        let color = UIColor (red: componentColor.red, green: componentColor.green, blue: componentColor.blue, alpha: 1)
        ctx?.addRect(size)
        
        ctx?.setLineWidth(lineWidht-1)
        ctx?.setStrokeColor(color.cgColor)
        ctx?.strokePath()
    }
    
    func  generateRandomColor() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        return (red, green, blue )
    }
    
    //MARK:  Check Intersections with saved objects
    func checkIntersectsInArea(planePosition: CGPoint, planeSize: CGSize, sector: Int, positionRadius: CGFloat ) ->Bool {
        
        var notIntersectsInArea = true
        
        if (allRandomPlanesInArea[sector].count != 0) {
            
            for savedPlane:AKPlane in allRandomPlanesInArea[sector] {
                
                let generatedRect =  CGRect (origin: planePosition, size: planeSize)
                let savedRect = CGRect (origin: savedPlane.position, size: savedPlane.size)
                
                if (generatedRect.intersects(savedRect) && !isOverlayPlane) {
                    
                    notIntersectsInArea = false
                    
                    return notIntersectsInArea
                }
                
            }
        }
        
        return notIntersectsInArea
        
    }
    //MARK: Count neighbors
    func countNeighbors(planePosition: CGPoint, planeSize: CGSize, sector: Int, positionRadius: CGFloat, delta:CGFloat){
        
        let overSizeX = planePosition.x-dimensionPlane
        let overSizeY = planePosition.y-dimensionPlane
        
        let overSizeDimension = 3*dimensionPlane
        
        let overSizePlane = CGRect (x: overSizeX, y: overSizeY, width: overSizeDimension, height: overSizeDimension)
        
        var ni:Int = 0
        var si:Int = 0
        
        for savedPlane:AKPlane in allRandomPlanesInArea[sector] {
            
            let savedRect = CGRect (origin: savedPlane.position, size: savedPlane.size)
            
            //            print ("\(overSizePlane)")
            //            print ("Sector:\(sector) NeigB:\(neighbors) SavP:\(savedRect)")
            if overSizePlane.intersects(savedRect) {
                neighbors += 1
                si += 1
            }
            ni += 1
        }
        
        let dia = 3 * planeRadius
        if (positionRadius + dia) >= inerAreaArray[sector].0 {
            
            neighbors += 1
        }
        if ((positionRadius - dia) <= inerAreaArray[sector].1) {
            
            neighbors += 1
        }
        print ("Sector:\(sector)\tfor:\(ni)-\(si) :: \(allRandomPlanesInArea[sector].count) :: nei:\(neighbors)")
        
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
