//
//  ConnectionLayer.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 29.12.2023.
//

import UIKit

final class ConnectionLayer: CAShapeLayer {
    private let firstView: TreeItemView
    private let secondView: TreeItemView
    private let addType: AddType
    private let frameCalculator = FrameCalculator.shared
    
    init(firstView: TreeItemView, secondView: TreeItemView, addType: AddType) {
        self.firstView = firstView
        self.secondView = secondView
        self.addType = addType
        super.init()
        configureLayer()
        connectViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConnectionLayer {
    func isChildOf(_ item: TreeItemView) -> Bool {
        addType == .child && (firstView == item || secondView == item)
    }
    
    func redraw() {
        connectViews()
    }
}

private extension ConnectionLayer {
    func configureLayer() {
        lineWidth = 1
        strokeColor = UIColor.black.cgColor
        fillColor = UIColor.clear.cgColor
    }
    
    func connectViews() {
        let bezierPath = UIBezierPath()
        
        switch addType {
        case .child:
            drawChildrenLines(bezierPath: bezierPath)
        case .parnter:
            drawParnerLines(bezierPath: bezierPath)
        }
        
        path = bezierPath.cgPath
    }
    
    func drawChildrenLines(bezierPath: UIBezierPath) {
        let firstPoint = frameCalculator.calculateCenterPoint(for: firstView)
        let rightAngleSpacing = frameCalculator.parentsBetweenChildrenSpacing / 2
        let firstRightAnglePoint = CGPoint(x: firstPoint.x, y: firstPoint.y + rightAngleSpacing)
        let secondRightAnglePoint = CGPoint(x: secondView.frame.midX, y:  secondView.frame.minY - rightAngleSpacing / 2)
        let finalPoint = CGPoint(x: secondView.frame.midX, y: secondView.frame.minY)
        
        bezierPath.move(to: firstPoint)
        bezierPath.addLine(to: firstRightAnglePoint)
        bezierPath.addLine(to: secondRightAnglePoint)
        bezierPath.addLine(to: finalPoint)
    }
    
    func drawParnerLines(bezierPath: UIBezierPath) {
        let firstPoint = CGPoint(x: firstView.frame.maxX, y: firstView.frame.midY)
        let secondPoint = CGPoint(x: secondView.frame.minX, y: secondView.frame.midY)
        
        bezierPath.move(to: firstPoint)
        bezierPath.addLine(to: secondPoint)
    }
}
