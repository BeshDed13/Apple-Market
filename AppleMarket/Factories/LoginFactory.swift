//
//  LoginFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

final class LoginFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> LoginViewController {
        let viewModel = LoginViewModel(
            authService: container.authService,
            userService: container.userService,
            currentUserManager: container.currentUserManager
            )
        return LoginViewController(
            viewModel: viewModel
        )
    }
}
