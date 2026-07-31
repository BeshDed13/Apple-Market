//
//  MainCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.07.2026.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let mainFactory: MainFactory
    
    init(
        navigationController: UINavigationController,
        mainFactory: MainFactory
    ) {
        self.navigationController = navigationController
        self.mainFactory = mainFactory
    }
    
    func start() {
        let vc = mainFactory.make()
        navigationController.pushViewController(vc, animated: true)
    }
}
