//
//  AKRadarViewController.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

//@IBDesignable

class AKRadarViewController: UIViewController {

    let numberOfLevels: Int = 2
    let numberOfPlanes: Int  = 15
    let lineWidht: CGFloat = 2
    weak var radarView: UIView!
    var levelCenterRadiusArray: [CGFloat] = []
    var levelDelta: CGFloat = 4
    var planeSize: CGFloat = 20
    var viewCenter: CGPoint = CGPoint(x: 0, y: 0)
    var anglePos: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        drawRadarView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        planeSize = planeSize > levelDelta ? levelDelta - 2*lineWidht : planeSize
        let planeSizeView = CGSize(width: planeSize, height: planeSize)

        // MARK: Place plane on RadarView
        var planeIndex = 0
        let planeCircleRadius = planeSize * CGFloat(sqrtf(2))
        let angleDelta = asin (planeCircleRadius / levelCenterRadiusArray[0])
        let numPlane = Int (2 * CGFloat.pi / angleDelta)
        while  planeIndex <= numPlane {
            let planeLocation = coordinateGeneration()
            drawPlaneView(planeCoordinate: planeLocation, planeSize: planeSizeView, borderWidht: lineWidht)
            planeIndex += 1
            print ("angle:\(anglePos)")
            self.anglePos = anglePos + angleDelta
        }
        print("innerRadius:\(levelCenterRadiusArray)")

    }

    func coordinateGeneration () -> CGPoint {
//        let fromDegree = 180 / CGFloat.pi
//        let toDegree =  CGFloat.pi / 180
        let randomRadiusIndex = Int.random(in: 0..<levelCenterRadiusArray.count)
        let randomDeltaRadius: CGFloat = 0
        let randomAngle = CGFloat(self.anglePos)
        //CGFloat.random(in: 0..360)
        let randomRadius =  randomDeltaRadius + levelCenterRadiusArray[randomRadiusIndex]
        let planePositionX = viewCenter.x + CGFloat(randomRadius * cos(randomAngle)) - planeSize / 2
        let planePositionY = viewCenter.y + CGFloat(randomRadius * sin(randomAngle)) -  planeSize / 2
        let coordinate = CGPoint(x: planePositionX, y: planePositionY)
        return coordinate
    }

    func drawPlaneView(planeCoordinate: CGPoint, planeSize: CGSize, borderWidht: CGFloat) {
        let planeView = AKPlaneView()
        planeView.planeLineWidht = borderWidht
        planeView.planeRect = true
        planeView.planeImage = true
        planeView.planeSize = planeSize
        planeView.frame = CGRect(origin: planeCoordinate, size: planeSize)
        planeView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.0)
        radarView.addSubview(planeView)
        radarView.bringSubviewToFront(planeView)
    }

    func drawRadarView() {

        let lineWidhtCorrection = 2*lineWidht
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        let radarRectSize = screenWidth > screenHeight ? screenHeight : screenWidth
        let halfFrameSize = radarRectSize / 2.0
        viewCenter.x = halfFrameSize
        viewCenter.y = halfFrameSize
        let viewRectX: CGFloat = 0
        let viewRectY: CGFloat = screenHeight/2.0 - halfFrameSize
        var levelRadius: CGFloat = halfFrameSize - lineWidhtCorrection
        levelDelta = levelRadius / CGFloat(numberOfLevels)
        let levelCenter = levelDelta / 2.0

        // MARK: Check Center
        print ("Screen size: width=\(screenWidth)\theight:\(screenHeight)")
        print ("viewY: \(viewRectY) = \(screenHeight)/2 :: \(radarRectSize)/2")
        print ("Frame Size:\(halfFrameSize)")
        let radarView = AKRadarView()
        radarView.radarLevelLineWidht = lineWidht
        radarView.radarLevelRadius = levelRadius
        radarView.radarLevelDelta = levelDelta
        radarView.radarCenter = CGPoint(x: halfFrameSize, y: halfFrameSize)
        radarView.radarLevelNumber = numberOfLevels
        radarView.radarLevelBorderColor = .black
        radarView.backgroundColor = .white
        radarView.frame = CGRect(x: viewRectX, y: viewRectY, width: radarRectSize, height: radarRectSize)
        self.view.addSubview(radarView)
        self.radarView = radarView
        radarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radarView.widthAnchor.constraint(equalToConstant: radarRectSize),
            radarView.heightAnchor.constraint(equalToConstant: radarRectSize),
            radarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            radarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        for _ in 0..<radarView.radarLevelNumber {
            let levelCenterRadius = levelRadius - levelCenter
            levelCenterRadiusArray.append(levelCenterRadius)
            levelRadius -= levelDelta
        }

    }

}
