//
//  SignUpViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

protocol SignUpViewModelProtocol: AnyObject {
    
    var didSignUpSuccessfully: (() -> Void)? { get set }

    func signUp(request: SignUpRequest)

}

final class SignUpViewModel: SignUpViewModelProtocol {
    
    var didSignUpSuccessfully: (() -> Void)?
    
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
    
    func signUp(request: SignUpRequest) {
        authService.signUp(
            request: request
        ) { [weak self] result in
            
                switch result {
                case .success(let uid):
                    
                    let user = UserModel(
                        id: uid,
                        name: request.name,
                        email: request.email,
                        avatar: request.avatar,
                        cartVariantIDs: [],
                        favoriteProductIDs: [],
                        orderIDs: []
                        )
                    self?.userService.createUser(user) { [weak self] result in
                        switch result {
                        case .success:
                            self?.currentUserManager.setUser(user)
                            self?.didSignUpSuccessfully?()
                            
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
