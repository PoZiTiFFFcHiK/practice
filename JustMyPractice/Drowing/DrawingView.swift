//
//  DrowingView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

final class DrawingView: UIView {
    
    private let drawingImageView = UIImageView()
    
    private var isItSwipe: Bool = false
    private var firstPoint: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor =  .white
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        isItSwipe = false
        firstPoint = firstTouch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let newPoint = firstTouch.location(in: self)
        isItSwipe = true
        drawLine(from: firstPoint, to: newPoint)
        firstPoint = newPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isItSwipe { drawLine(from: firstPoint, to: firstPoint) }
    }
}

private extension DrawingView {
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawingImageView.image?.draw(in: bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setLineWidth(10)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setBlendMode(.normal)
        context.strokePath()
        
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func addSubviews() {
        addSubview(drawingImageView)
    }
    
    func makeConstraints() {
        drawingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawingImageView.topAnchor.constraint(equalTo: topAnchor),
            drawingImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            drawingImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            drawingImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
