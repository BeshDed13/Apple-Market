//
//  LoginViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    
    var didLoginSuccessfully: (() -> Void)? { get set }
    
    func login(request: LoginRequest)
}

final class LoginViewModel: LoginViewModelProtocol {
    
    var didLoginSuccessfully: (() -> Void)?
    
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let currentUserManager: CurrentUserManagerProtocol
    
    init(
        authService: AuthServiceProtocol,
        userService: UserServiceProtocol,
        currentUserManager: CurrentUserManagerProtocol
    ) {
        self.authService = authService
        self.userService = userService
        self.currentUserManager = currentUserManager
    }
    
    func login(request: LoginRequest) {
        authService.login(request: request) { [weak self] result in
            switch result {
            case .success:
                guard
                    let self,
                    let uid = self.authService.currentUserID
                else {
                    return
                }
                self.userService.fetchUser(uid: uid) { result in
                    switch result {
                    case .success(let user):
                        self.currentUserManager.setUser(user)
                        self.didLoginSuccessfully?()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
