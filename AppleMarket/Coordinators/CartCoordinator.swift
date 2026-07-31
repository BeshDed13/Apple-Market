//
//  CartCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.07.2026.
//

import UIKit

final class CartCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var onLoginRequested: (() -> Void)?
    var onSignUpRequested: (() -> Void)?
    
    private let cartFactory: CartFactory
    
    init(
        navigationController: UINavigationController,
        cartFactory: CartFactory
    ) {
        self.navigationController = navigationController
        self.cartFactory = cartFactory
    }
    
    func start() {
        let vc = cartFactory.make()
        
        vc.onLoginTapped = { [weak self] in
            self?.onLoginRequested?()
        }
        
        vc.onSignUpTapped = { [weak self] in
            self?.onSignUpRequested?()
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

