//
//  AuthService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {

    var currentUserID: String? { get }

    var isAuthorized: Bool { get }

    var authState: AuthState { get }

    func login(
        request: LoginRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func signUp(
        request: SignUpRequest,
        completion: @escaping (Result<String, Error>) -> Void
    )

    func logout() throws
}

final class AuthService: AuthServiceProtocol {

    private let userService: UserServiceProtocol

    private(set) var authState: AuthState = .loading

    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }

    var isAuthorized: Bool {
        if case .authorized = authState {
            return true
        }

        return false
    }

    init(userService: UserServiceProtocol) {
        self.userService = userService

        checkAuthState()
    }

    private func checkAuthState() {

        guard let uid = currentUserID else {
            authState = .guest
            return
        }

        userService.fetchUser(uid: uid) { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success(let user):
                    self?.authState = .authorized(user)

                case .failure:
                    self?.authState = .guest
                }
            }
        }
    }

    func login(
        request: LoginRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        Auth.auth().signIn(
            withEmail: request.email,
            password: request.password
        ) { [weak self] result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(AuthError.userNotCreated))
                return
            }

            self?.userService.fetchUser(uid: uid) { result in

                DispatchQueue.main.async {

                    switch result {

                    case .success(let user):
                        self?.authState = .authorized(user)
                        completion(.success(()))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func signUp(
        request: SignUpRequest,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        Auth.auth().createUser(
            withEmail: request.email,
            password: request.password
        ) { [weak self] result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let firebaseUser = result?.user else {
                completion(.failure(AuthError.userNotCreated))
                return
            }

            let user = UserModel(
                id: firebaseUser.uid,
                name: request.name,
                email: request.email,
                avatar: request.avatar,
                cartVariantIDs: [],
                favoriteProductIDs: [],
                orderIDs: []
            )

            self?.userService.createUser(user) { result in

                DispatchQueue.main.async {

                    switch result {

                    case .success:
                        self?.authState = .authorized(user)
                        completion(.success(firebaseUser.uid))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func logout() throws {

        try Auth.auth().signOut()

        authState = .guest
    }
}
