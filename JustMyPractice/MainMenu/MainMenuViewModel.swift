//
//  MainMenuViewModel.swift
//  JustMyPractice
//
//  Created by Vladimir Petrov on 10.12.2023.
//

struct MainMenuViewModel {
    private let model = MainMenuModel()
    
    func getMenuItems() -> [MenuRowModel] {
        model.menuItems.enumerated().map { .init(title: "\($0.offset + 1). \($0.element.title)") }
    }
    
    func getMenuItem(by index: Int) -> MainMenuItem {
        model.menuItems[index]
    }
}
