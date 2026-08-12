//
//  ProfileViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 27.07.2026.
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    
    var authState: AuthState { get }
    
    var onStateChanged: (() -> Void)? { get set }
    
    func loadProfile()
    func logout()
}

@MainActor
final class ProfileViewModel: ProfileViewModelProtocol {
    
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
    
    func loadProfile() {
        authState = .loading

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
    
    func logout() {
        do {
            try authService.logout()
            authState = .guest
        } catch {
            print("Logout error:", error)
        }
    }
}
