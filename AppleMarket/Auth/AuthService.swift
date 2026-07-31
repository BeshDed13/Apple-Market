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
    
    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isAuthorized: Bool {
        currentUserID != nil
    }
    
    func login(
        request: LoginRequest,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: request.email,
            password: request.password
        ) { _, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    func signUp(
        request: SignUpRequest,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: request.email,
            password: request.password
        ) { result, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(AuthError.userNotCreated))
                return
            }
            
            completion(.success(uid))
        }
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}
