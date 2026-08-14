//
//  NotificationsFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class NotificationsFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make(user: UserModel) -> NotificationsViewController {
        
        let viewModel = NotificationsViewModel(
            notificationService: container.notificationService,
            userId: user.id
        )
        return NotificationsViewController(
            viewModel: viewModel
        )
    }
}
