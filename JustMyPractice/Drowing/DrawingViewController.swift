//
//  ViewController.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

class DrawingViewController: UIViewController {

    private let contentView = DrawingView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

