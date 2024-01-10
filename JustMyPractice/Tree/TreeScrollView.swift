//
//  TreeScrollView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 29.12.2023.
//

import UIKit

final class TreeScrollView: UIView {
    private var contentView: UIView? { subviews.first }
    
    private var contentSize: CGSize = .zero {
        didSet {
            contentView?.frame.size = contentSize
        }
    }
    
    private var contentOffset: CGPoint = .zero {
        didSet {
            contentView?.frame.origin = CGPoint(x: -contentOffset.x, y: -contentOffset.y)
        }
    }
    
    private var state: State = .default
    
    private var contentOffsetBounds: CGRect {
        let width = contentSize.width - bounds.width
        let height = contentSize.height - bounds.height
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addRegonaziers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TreeScrollView {
    enum State {
        case `default`
        case swaped(initialOffset: CGPoint)
    }
}

private extension TreeScrollView {
    @objc
    func viewDidSwiped(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            state = .swaped(initialOffset: contentOffset)
        case .changed:
            let translation = sender.translation(in: self)
            if case let .swaped(initialOffset) = state {
                contentOffset = initialOffset - translation
            }
        case .ended:
            state = .default
        case .cancelled, .failed:
            state = .default
        case .possible:
            break
        @unknown default:
            fatalError()
        }
    }
}

private extension TreeScrollView {
    func addRegonaziers() {
        let panGestrureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDidSwiped))
        addGestureRecognizer(panGestrureRecognizer)
    }
}

// TODO: Вынести
private extension CGPoint {
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}

