//
//  AKRadarViewController.swift
//  TestRadar
//
//  Created by Andrei Kucherenko on 24/11/2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class AKRadarViewController: UIViewController {

    // MARK: Define parameters
    let numberOfLevels: Int = 1
    let numberOfPlanes: Int  = 10
    let lineWidht: CGFloat = 2
    weak var radarView: UIView!
    var levelRadiusArray: [CGFloat] = []
    var levelDelta: CGFloat = 4
    var planeSize: CGFloat = 30
    var viewCenter: CGPoint = CGPoint(x: 0, y: 0)
    var anglePos: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        drawRadarView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let planeCircleDia = 2 * planeSize / CGFloat(sqrtf(2))
        planeSize = planeCircleDia > levelDelta ? (levelDelta * CGFloat(sqrtf(2)) / 2 ) : planeSize
        let planeSizeView = CGSize(width: planeSize, height: planeSize)

        // MARK: Place plane on RadarView
        var planeIndex = 0

        while  planeIndex < numberOfPlanes {
            let planeLocation = coordinateGeneration()
            drawPlaneView(planeCoordinate: planeLocation, planeSize: planeSizeView, borderWidht: lineWidht)
            planeIndex += 1
        }

    }

    // MARK: Plane coordinate random generation
    func coordinateGeneration () -> CGPoint {
        let fromDegree =  CGFloat.pi / 180
        let randomRadiusIndex = Int.random(in: 0..<levelRadiusArray.count)
        let planeCircleRadius = planeSize / CGFloat(sqrtf(2))
        let halfPlaneSize = planeSize / 2
        var levelDeltaCorrection = levelDelta - planeSize - 4 * lineWidht
        if randomRadiusIndex == levelRadiusArray.count - 1 {
            levelDeltaCorrection = levelDelta
        }
        let randomDeltaRadius: CGFloat = levelDeltaCorrection > 0 ? CGFloat.random(in: 0...levelDeltaCorrection) : 0
        let randomAngle = CGFloat.random(in: 0...360) * fromDegree
        let randomRadius =  levelRadiusArray[randomRadiusIndex] - randomDeltaRadius - planeCircleRadius
        let planePositionX = viewCenter.x + CGFloat(randomRadius * cos(randomAngle)) - halfPlaneSize
        let planePositionY = viewCenter.y + CGFloat(randomRadius * sin(randomAngle)) - halfPlaneSize
        let coordinate = CGPoint(x: planePositionX, y: planePositionY)
        return coordinate
    }

    // MARK: PlaneView creation
    func drawPlaneView(planeCoordinate: CGPoint, planeSize: CGSize, borderWidht: CGFloat) {
        let planeView = AKPlaneView()
//        planeView.planeImageName = "Plane145x145"
        planeView.planeLineWidht = borderWidht
        planeView.planeRectShow = true
        planeView.planeImageShow = true
        planeView.planeSize = planeSize
        planeView.frame = CGRect(origin: planeCoordinate, size: planeSize)
        planeView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.0)
        radarView.addSubview(planeView)
        radarView.bringSubviewToFront(planeView)
    }

    // MARK: RadarView creation
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
        let radarView = AKRadarView()
        radarView.radarLevelsLineWidht = lineWidht
        radarView.radarLevelsRadius = levelRadius
        radarView.radarLevelsDelta = levelDelta
        radarView.radarCenter = CGPoint(x: halfFrameSize, y: halfFrameSize)
        radarView.radarLevelsNumber = numberOfLevels
        radarView.radarLevelsBorderColor = .black
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

        for _ in 0..<radarView.radarLevelsNumber {
            levelRadiusArray.append(levelRadius)
            levelRadius -= levelDelta
        }
    }

}
