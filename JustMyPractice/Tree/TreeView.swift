//
//  TreeView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 29.12.2023.
//

import UIKit

enum AddType {
    case parnter
    case child
}

final class TreeView: UIView {
    private let scrollView = TreeScrollView()
    private let contentView = UIView()
    private lazy var plusButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private var connectionLayers: Set<ConnectionLayer> = []
    
    private let frameCalculator = FrameCalculator.shared
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.center = center
    }
}

extension TreeView {
    enum State {
        case `default`
        case swaped(initialOffset: CGPoint)
    }
}

extension TreeView: TreeItemViewDelegate {
    func treeItemDidChangePosition() {
        // connectViews(oldView: firstView)
    }
}

extension TreeView: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let selectedChild = interaction.view as? TreeItemView else { return nil }
        return .init(actionProvider: { [weak self] _ in self?.createActionProvider(for: selectedChild) })
    }
    
    private func createActionProvider(for item: TreeItemView) -> UIMenu {
        let addPartnerAction = UIAction(title: "Add a partner") { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.addNewItemToView(connectedView: item, addType: .parnter)
            }
        }
        let addChildAction = UIAction(title: "Add a child") { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.addNewItemToView(connectedView: item, addType: .child)
            }
        }
        return .init(children: [addPartnerAction, addChildAction])
    }
}

private extension TreeView {
    func addNewItemToView(connectedView: TreeItemView, addType: AddType) {
        switch addType {
        case .parnter:
            addNewPartnerToView(connectedView: connectedView)
        case .child:
            addNewChildToView(connectedView: connectedView)
        }
    }
    
    func addNewPartnerToView(connectedView: TreeItemView) {
        let newItem = createNewItem(connectedView: connectedView, addType: .parnter)
        addNewLayer(firstView: connectedView, secondView: newItem, addType: .parnter)
        contentView.addSubview(newItem)
    }
    
    func addNewChildToView(connectedView: TreeItemView) {
        let newItem = createNewItem(connectedView: connectedView, addType: .child)
        
        newItem.frame = frameCalculator.calculateFrame(for: newItem, connectedWith: connectedView, addType: .child)
        connectedView.addChild(newItem)
        redrawChildrenConnections(for: connectedView)
        
        addNewLayer(firstView: connectedView, secondView: newItem, addType: .child)
        contentView.addSubview(newItem)
    }
    
    func addNewLayer(firstView: TreeItemView, secondView: TreeItemView, addType: AddType) {
        let newLayer = ConnectionLayer(firstView: firstView, secondView: secondView, addType: addType)
        connectionLayers.insert(newLayer)
        contentView.layer.addSublayer(newLayer)
    }
    
    func redrawChildrenConnections(for view: TreeItemView) {
        connectionLayers.filter { $0.isChildOf(view) }.forEach { $0.redraw() }
    }
    
    func createNewItem(connectedView: TreeItemView, addType: AddType) -> TreeItemView {
        let newItem = TreeItemView(partner: addType == .parnter ? connectedView : nil)
        newItem.frame = frameCalculator.calculateFrame(for: newItem, connectedWith: connectedView, addType: addType)
        newItem.interactions = [UIContextMenuInteraction(delegate: self)]
        return newItem
    }
    
    @objc
    func plusButtonDidTapped() {
        let firstItem = TreeItemView()
        firstItem.interactions = [UIContextMenuInteraction(delegate: self)]
        contentView.addSubview(firstItem)
        firstItem.center = center
        plusButton.isHidden = true
    }
    
    func addSubviews() {
        contentView.addSubview(plusButton)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    func makeConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}
