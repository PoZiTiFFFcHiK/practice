//
//  MainMenuItem.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

enum MainMenuItem: CaseIterable {
    case drawing
    case synchronousDrawing
}

extension MainMenuItem {
    var title: String {
        switch self {
        case .drawing:
            return "Drawing"
        case .synchronousDrawing:
            return "Synchronous Drawing"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .drawing:
            return DrawingViewController()
        case .synchronousDrawing:
            return SynchronousDrawingViewController()
        }
    }
}
