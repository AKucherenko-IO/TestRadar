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
    let numberOfCircles: Int = 2
    let numberOfPlanes: Int = 10
    var planeDimention: CGFloat = 30
    let dimentionDelta: CGFloat = 2
    let cirlcleColor: UIColor = UIColor.green
    let circleBorderColor: UIColor = UIColor.black
    
    var allRandomPlanesInArea = [[AKPlane]]()
//    var allPlanesInSector: Array <Int> = []
    var randomPlanesInSector : Set <String> = Set()
    var radiusRadarArray: [CGFloat] = []
    var planeRadius: CGFloat = 0
    
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
        
        planeDimention =  radiusDelta > planeDimention ? planeDimention : radiusDelta/2
        
        planeRadius = sqrt(2)/2 * planeDimention

        //MARK: - Generate Planes locations
        var i: Int = 1;
  
        while  (i <= numberOfPlanes) {
            
            let planeLocationX = CGFloat.random(in: 0..<frameSize)
            let planeLocationY = CGFloat.random(in: 0..<frameSize)
            let (flag1, sector) = checkPosition(x: planeLocationX, y: planeLocationY, center: center, delta: radiusDelta)

            if (flag1) {
                let planeLocation = CGPoint (x: planeLocationX, y: planeLocationY)
                let planeSize = CGSize (width: planeDimention, height: planeDimention)
                let plane = CGRect (origin: planeLocation, size: planeSize)
    
                let randomColor = generateRandomColor()
                let planeColor = UIColor (red: randomColor.red, green: randomColor.green, blue: randomColor.blue, alpha: 1)
                drawRectangle(size: plane, color: planeColor.cgColor)
                randomPlanesInSector.insert(plane.debugDescription)
                i += 1
            }
            
        }
        
    }
    //MARK: Count Positions
    func countPositionInSector(rMax:Int, rMin:Int) -> Int {
        
        var countedPlaneInSector = 0
        var numberInCurCircle = 0
        let planeRad = Int(planeRadius)
        var rInArea = rMax - planeRad
        let rMinCalc = rMin + planeRad
        while (rInArea >= rMinCalc) {
            let lCurCircle = 2 * Double(rInArea) * Double.pi
            numberInCurCircle = Int(lCurCircle / (2*Double(planeRadius)))
            countedPlaneInSector +=  numberInCurCircle
            rInArea -= 2*planeRad
        }
        return countedPlaneInSector
    }
    
    func testArray() {
        var arr0: [Array<CGRect>] = []
        var arr1: [CGRect] = []
        let rect = CGRect.zero
        arr1.append(rect)
        arr0.append(arr1)
        print(arr1)
    }
    
    func  generateRandomColor() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        
        let red = CGFloat.random(in: 0...1.0)
        let green = CGFloat.random(in: 0...1.0)
        let blue = CGFloat.random(in: 0...1.0)
        return (red, green, blue )
    }
    func checkPlaneExistense (sector: Int, randomPlane: CGRect) -> Bool {
//        let planeInThisSector = randomPlanesInSector[sector]
//        let arraySize = planeInThisSector.
//        if ( arraySize != 0 ){
//
//            for i in 0...arraySize {
//
//                if
//            }
//
//        }
        
        return true
    }
    func checkPosition(x: CGFloat, y: CGFloat, center: CGPoint, delta: CGFloat) -> (flag:Bool , sector: Int) {
        
        var isInsideArea = false
        var radarBorderIn = CGFloat(0)
        let halfSize = planeDimention / 2.0
        let planeCenterX = x + halfSize
        let planeCenterY = y + halfSize
        let xDelta = planeCenterX - center.x
        let yDelta = planeCenterY - center.y
        let conditionRule = pow(xDelta,2) + pow(yDelta,2)
        let positionRadius = sqrt(conditionRule)
        var sector = Int (abs((radiusRadarArray[0] - positionRadius)) / delta)
        sector = (positionRadius != 0 ) ? sector :  radiusRadarArray.count - 1
      
        let correctionOut = radiusRadarArray[sector] - planeRadius - lineWidht - dimentionDelta
        let radarBorderOut  = pow(correctionOut,2)
        if (sector < radiusRadarArray.count - 1) {
            let correctionIn = radiusRadarArray[sector+1] + planeRadius + lineWidht + dimentionDelta
            radarBorderIn  = pow(correctionIn,2)
        }

        if (radarBorderOut > conditionRule)&&( conditionRule >= radarBorderIn) {
            
           
//            print ("\(radarBorderOut) > \(conditionRule) x:\(x) y:\(y) radius:\(radiusRadarArray[sector]) palane R:\(planeRadius) center:\(center)")
            
            

            for savedPlane:AKPlane in allRandomPlanesInArea[sector] {
                let generatedRect =  CGRect (x: x, y: y, width: planeDimention, height: planeDimention)
                let savedRect = CGRect (origin: savedPlane.position, size: savedPlane.size)
                if generatedRect.intersects(savedRect) {
                    
                    isInsideArea = false
                    
                    return (isInsideArea, sector)
                }else{
                    print ("\(sector)\tSAV:\(savedRect)\tGEN:\(generatedRect)")
                    isInsideArea = true
                    let genPlane = AKPlane ()
                    genPlane.position = CGPoint (x: x, y: y)
                    genPlane.size = CGSize (width: planeDimention, height: planeDimention)
                    allRandomPlanesInArea[sector].append(genPlane)
                    
                    var planeImage:UIImageView?
                    var image:UIImage = UIImage (named: "plane-2")!
                    planeImage = UIImageView(image: image)
                    planeImage!.frame = CGRect(origin: genPlane.position, size: genPlane.size)
                    self.addSubview(planeImage!)
                    
                    if (positionRadius + planeRadius) >= radiusRadarArray[sector] {
                        savedPlane.neighbors += 1
                    }
                    if ((positionRadius - planeRadius) <= radiusRadarArray[sector]-delta) {
                        savedPlane.neighbors += 1
                    }
                    let nRect = CGRect (x: x-1, y: y-1, width: planeDimention+2, height: planeDimention+2)
                    if nRect.intersects(savedRect) {
                        savedPlane.neighbors += 1
                    }
                    
                }
            }
            if (allRandomPlanesInArea[sector].count == 0) {
                let genPlane = AKPlane ()
                genPlane.position = CGPoint (x: x, y: y)
                genPlane.size = CGSize (width: planeDimention, height: planeDimention)
                allRandomPlanesInArea[sector].append(genPlane)
                isInsideArea = true
                
                var planeImage:UIImageView?
                var image:UIImage = UIImage (named: "plane-1")!
                planeImage = UIImageView(image: image)
                planeImage!.frame = CGRect(origin: genPlane.position, size: genPlane.size)
                self.addSubview(planeImage!)
                
            }
        }
        
        return  (isInsideArea, sector)
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
