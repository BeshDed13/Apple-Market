//
//  SettingsFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class SettingsFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make(user: UserModel) -> SettingsViewController {
        
        let viewModel = SettingsViewModel(
            userService: container.userService,
            user: user
        )
        return SettingsViewController(
            viewModel: viewModel
        )
    }
}
