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
    private let ordersFactory: OrdersFactory
    private let settingsFactory: SettingsFactory
    private let supportFactory: SupportFactory
    private let notificationsFactory: NotificationsFactory
    
    init(
        navigationController: UINavigationController,
        profileFactory: ProfileFactory,
        ordersFactory: OrdersFactory,
        settingsFactory: SettingsFactory,
        supportFactory: SupportFactory,
        notificationsFactory: NotificationsFactory
    ) {
        self.navigationController = navigationController
        self.profileFactory = profileFactory
        self.ordersFactory = ordersFactory
        self.settingsFactory = settingsFactory
        self.supportFactory = supportFactory
        self.notificationsFactory = notificationsFactory
    }
    
    func start() {
        let vc = profileFactory.make()
        
        vc.onLoginTapped = { [weak self] in
            self?.onLoginRequested?()
        }
        
        vc.onSignUpTapped = { [weak self] in
            self?.onSignUpRequested?()
        }
        
        vc.onOrdersTapped = { [weak self] user in
            self?.showOrders(user: user)
        }
        
        vc.onSettingsTapped = { [weak self] in
            self?.showSettings()
        }
        
        vc.onSupportTapped = { [weak self] in
            self?.showSupport( )
        }
        
        vc.onNotificationsTapped = { [weak self] user in
            self?.showNotifications(user: user)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showOrders(user: UserModel) {
        let vc = ordersFactory.make(user: user)

        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func showSettings() {
        let vc = settingsFactory.make()

        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func showSupport() {
        let vc = supportFactory.make()

        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func showNotifications(user: UserModel) {
        let vc = notificationsFactory.make(user: user)
        
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
}
