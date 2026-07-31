//
//  ProfileCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.07.2026.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var onLoginRequested: (() -> Void)?
    var onSignUpRequested: (() -> Void)?
    
    private let profileFactory: ProfileFactory
    
    init(
        navigationController: UINavigationController,
        profileFactory: ProfileFactory
    ) {
        self.navigationController = navigationController
        self.profileFactory = profileFactory
    }
    
    func start() {
        let vc = profileFactory.make()
        
        vc.onLoginTapped = { [weak self] in
            self?.onLoginRequested?()
        }
        
        vc.onSignUpTapped = { [weak self] in
            self?.onSignUpRequested?()
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
