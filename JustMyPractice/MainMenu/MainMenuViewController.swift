//
//  MainMenuViewController.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

final class MainMenuViewController: UIViewController {
    private lazy var contentView: MainMenuView = {
        let view = MainMenuView()
        view.delegate = self
        return view
    }()
    private let viewModel = MainMenuViewModel()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.configure(with: viewModel.getMenuItems())
    }
}

extension MainMenuViewController: MainMenuViewDelegate {
    func didSelectRow(at index: Int) {
        let menuItem = viewModel.getMenuItem(by: index)
        navigationController?.pushViewController(menuItem.viewController, animated: true)
    }
}
