//
//  AuthCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 25.07.2026.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var onFinish: (() -> Void)?
    
    var childCoordinators: [ Coordinator] = []
    
    private weak var navigationController: UINavigationController?
    
    private let loginFactory: LoginFactory
    private let signUpFactory: SignUpFactory
    
    init(
        navigationController: UINavigationController,
         loginFactory: LoginFactory,
         signUpFactory: SignUpFactory
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.signUpFactory = signUpFactory
    }
    
    func start() { }
    
    func showLogin(
        from navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        let vc = loginFactory.make()
        vc.onLoginSuccess = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSignUp(
        from navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        let vc = signUpFactory.make()
        vc.onSignUpSuccess = { [weak self] in
            self?.finish()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func finish() {
        guard let navigationController else { return }

        navigationController.popToRootViewController(animated: true)
        onFinish?()
    }
}
