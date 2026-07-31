//
//  Coordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 25.06.2026.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
