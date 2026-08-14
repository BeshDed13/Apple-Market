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
    var onOrderCreated: (() -> Void)?
    
    private let cartFactory: CartFactory
    private let checkoutFactory: CheckoutFactory
    
    init(
        navigationController: UINavigationController,
        cartFactory: CartFactory,
        checkoutFactory: CheckoutFactory
    ) {
        self.navigationController = navigationController
        self.cartFactory = cartFactory
        self.checkoutFactory = checkoutFactory
    }
    
    func start() {
        let vc = cartFactory.make()
        
        vc.onLoginTapped = { [weak self] in
            self?.onLoginRequested?()
        }
        
        vc.onSignUpTapped = { [weak self] in
            self?.onSignUpRequested?()
        }
        
        vc.onPlaceAnOrderTapped = { [weak self] cartProducts, user in
            self?.showCheckout(
                cartProducts: cartProducts,
                user: user
            )
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showCheckout(
        cartProducts: [CartProduct],
        user: UserModel
    ) {
        
        let vc = checkoutFactory.make(
            cartProducts: cartProducts,
            user: user
        )
        
        vc.onOrderCreated = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
}

