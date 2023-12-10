//
//  MainMenuView.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

import UIKit

protocol MainMenuViewDelegate: AnyObject {
    func didSelectRow(at index: Int)
}

final class MainMenuView: UIView {
    weak var delegate: MainMenuViewDelegate?
    
    private var rows: [MenuRowModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainMenuView {
    func configure(with rows: [MenuRowModel]) {
        self.rows = rows
    }
}

extension MainMenuView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = rows[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectRow(at: indexPath.row)
    }
}

private extension MainMenuView {
    func addSubviews() {
        addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
