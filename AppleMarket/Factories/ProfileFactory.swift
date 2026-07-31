//
//  ProfileFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

final class ProfileFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> ProfileViewController {
        let viewModel = ProfileViewModel(
            authService: container.authService,
            userService: container.userService
            )
        return ProfileViewController(
            viewModel: viewModel
        )
    }
}
