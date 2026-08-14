//
//  OrdersFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class OrdersFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make(user: UserModel) -> OrdersViewController {
        let viewModel = OrdersViewModel(
            orderService: container.orderService,
            userId: user.id
        )
        return OrdersViewController(
            viewModel: viewModel
        )
    }
}
