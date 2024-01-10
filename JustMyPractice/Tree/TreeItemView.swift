//
//  TreeItemView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 29.12.2023.
//

import UIKit

protocol TreeItemViewDelegate: AnyObject {
    func treeItemDidChangePosition()
}

final class TreeItemView: UIView {
    weak var delegate: TreeItemViewDelegate?
    
    var hasPartner: Bool { partner == nil }
    
    private(set) weak var partner: TreeItemView?
    private(set) var children: [TreeItemView] = []
    
    init(frame: CGRect = Constants.defaultFrame, partner: TreeItemView? = nil) {
        self.partner = partner
        super.init(frame: frame)
        configureLayer()
        setupRecognizers()
        partner?.setPartner(self)
    }
    
    func setPartner(_ partner: TreeItemView) {
        self.partner = partner
    }
    
    func addChild(_ child: TreeItemView) {
        FrameCalculator.shared.moveChildren(for: self)
        children.append(child)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TreeItemView {
    enum Constants {
        static let defaultFrame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
    }
    
    func configureLayer() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
    
    func setupRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDidMove))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func viewDidMove(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        sender.setTranslation(.zero, in: self)
        delegate?.treeItemDidChangePosition()
    }
}

extension CGRect {
    func decreasingX(_ float: CGFloat) -> CGRect {
        .init(x: minX - float, y: minY, width: width, height: height)
    }
}
