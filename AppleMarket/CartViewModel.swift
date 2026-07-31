//
//  CartViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 31.07.2026.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    
    var authState: AuthState { get }
    
    var onStateChanged: (() -> Void)? { get set }
    
    func loadCart()
}

@MainActor
final class CartViewModel: CartViewModelProtocol {
    
    var onStateChanged: (() -> Void)?
    
    private(set) var authState: AuthState = .loading {
        didSet {
            onStateChanged?()
        }
    }
    
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
    }
    
    func loadCart() {

        guard authService.isAuthorized,
              let userId = authService.currentUserID else {
            authState = .guest
            return
        }

        userService.fetchUser(uid: userId) { [weak self] result in

            guard let self else { return }

            Task { @MainActor in
                switch result {
                case .success(let user):
                    self.authState = .authorized(user)

                case .failure:
                    self.authState = .guest
                }
            }
        }
    }
}

