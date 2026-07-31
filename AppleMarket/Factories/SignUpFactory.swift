//
//  SignUpFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

final class SignUpFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> SignUpViewController {
        let viewModel = SignUpViewModel(
            authService: container.authService,
            userService: container.userService,
            currentUserManager: container.currentUserManager
            )
        return SignUpViewController(
            viewModel: viewModel
        )
    }
}
