//
//  ThreeViewController.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 29.12.2023.
//

import UIKit

final class TreeViewController: UIViewController {
    private lazy var contentView: TreeView = {
        let view = TreeView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func loadView() {
        view = contentView
    }
}

private extension TreeViewController {
    func configureNavigationBar() {
        let plusItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapPlusButton))
        navigationItem.rightBarButtonItems = [plusItem]
    }
    
    @objc
    func didTapPlusButton() {
        let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addPartnerAction = UIAlertAction(title: "Add a partner", style: .default) { [weak self] _ in
            // self?.addPartner()
        }
        let addChildAction = UIAlertAction(title: "Add a child", style: .default) { [weak self] _ in
            // self?.addChild()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        [addPartnerAction, addChildAction, cancelAction].forEach { alertViewController.addAction($0) }
        present(alertViewController, animated: true)
    }
}
