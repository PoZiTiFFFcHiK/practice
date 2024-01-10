//
//  FrameCalculator.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 02.01.2024.
//

import UIKit

struct FrameCalculator {
    static let shared = FrameCalculator()
    
    let parentsBetweenChildrenSpacing = Constants.oneAndHalfHeight
    
    func calculateFrame(for view: TreeItemView, connectedWith connectedView: TreeItemView, addType: AddType) -> CGRect {
        let originPoint = calculateOriginPoint(connectedView: connectedView, addType: addType)
        return .init(origin: originPoint, size: Constants.defaultSize)
    }
    
    func moveChildren(for view: TreeItemView) {
        view.children.forEach { child in
            child.frame = child.frame.decreasingX(Constants.childMovingValue)
        }
    }
    
    func calculateCenterPoint(for view: TreeItemView) -> CGPoint {
        if let partner = view.partner {
            let centerBetweenPartners = (view.frame.midX + partner.frame.midX) / 2
            return CGPoint(x: centerBetweenPartners, y: view.frame.midY)
        } else {
            return CGPoint(x: view.frame.midX, y: view.frame.maxY)
        }
    }
}

private extension FrameCalculator {
    enum Constants {
        static let defaultHeight: CGFloat = 100
        static let defaultWidth: CGFloat = 100
        static let childrenSpacing: CGFloat = 50
        static let devidedWidth: CGFloat = defaultWidth / 2
        static let doubleWidth: CGFloat = defaultWidth * 2
        static let doubleHeight: CGFloat = defaultHeight * 2
        static let oneAndHalfHeight: CGFloat = defaultHeight * 1.5
        static let childMovingValue: CGFloat = defaultWidth * 0.75
        static let defaultSize: CGSize = .init(width: defaultWidth, height: defaultHeight)
    }
    
    func calculateOriginPoint(connectedView: TreeItemView, addType: AddType) -> CGPoint {
        switch addType {
        case .child:
            if let lastChildren = connectedView.children.last {
                return lastChildren.frame.origin.addingX(Constants.defaultWidth + Constants.childrenSpacing)
            } else {
                return calculateCenterPoint(for: connectedView).descreasingX(Constants.devidedWidth).addingY(Constants.oneAndHalfHeight)
            }
        case .parnter:
            return connectedView.frame.origin.addingX(Constants.doubleWidth)
        }
    }
}

extension CGPoint {
    func addingY(_ float: CGFloat) -> CGPoint {
        .init(x: x, y: y + float)
    }
    
    func addingX(_ float: CGFloat) -> CGPoint {
        .init(x: x + float, y: y)
    }
    
    func descreasingY(_ float: CGFloat) -> CGPoint {
        .init(x: x, y: y - float)
    }
    
    func descreasingX(_ float: CGFloat) -> CGPoint {
        .init(x: x - float, y: y)
    }
}

