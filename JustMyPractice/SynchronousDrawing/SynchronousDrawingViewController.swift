//
//  SynchronousDrawingViewController.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

class SynchronousDrawingViewController: UIViewController {

    private let contentView = SynchronousDrawingView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


