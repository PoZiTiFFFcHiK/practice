//
//  SynchronousDrawingView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

final class SynchronousDrawingView: UIView {
    
    private let firstDrawingView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(rawValue: 251), for: .vertical)
        imageView.backgroundColor = .white
        return imageView
    }()
    private let secondDrawingView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(rawValue: 251), for: .vertical)
        imageView.backgroundColor = .white
        return imageView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstDrawingView, secondDrawingView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var isItSwipe: Bool = false
    private var firstPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor =  .lightGray
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        isItSwipe = false
        let superviewPoint = firstTouch.location(in: self)
        guard firstDrawingView.point(inside: superviewPoint, with: nil) else {
            return
        }
        firstPoint = firstDrawingView.convert(superviewPoint, from: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let superviewNewPoint = firstTouch.location(in: firstDrawingView)
        guard firstDrawingView.point(inside: superviewNewPoint, with: nil) else {
            return
        }
        isItSwipe = true
        drawLine(from: firstPoint, to: superviewNewPoint)
        firstPoint = superviewNewPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isItSwipe { drawLine(from: firstPoint, to: firstPoint) }
    }
}

private extension SynchronousDrawingView {
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(firstDrawingView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        print("First point is \(fromPoint), second point is \(toPoint)")
        
        firstDrawingView.image?.draw(in: firstDrawingView.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setLineWidth(10)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setBlendMode(.normal)
        context.strokePath()
        
        firstDrawingView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(secondDrawingView.frame.size)
        firstDrawingView.image?.draw(in: secondDrawingView.bounds)
        secondDrawingView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func addSubviews() {
        addSubview(stackView)
    }
    
    func makeConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
