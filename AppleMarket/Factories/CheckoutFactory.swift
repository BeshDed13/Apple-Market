//
//  CheckoutFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import UIKit

final class CheckoutFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make(
        cartProducts: [CartProduct],
        user: UserModel
    ) -> CheckoutViewController {
        
        let viewModel = CheckoutViewModel(
            storeService: container.storeService,
            orderService: container.orderService,
            cartService: container.cartService,
            notificationService: container.notificationService,
            user: user,
            cartProducts: cartProducts
        )
        
        return CheckoutViewController(
            viewModel: viewModel
        )
    }
}
