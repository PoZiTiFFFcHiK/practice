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
    }
    
    override func loadView() {
        view = contentView
    }
}
