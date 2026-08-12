//
//  UserService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {

    func createUser(
        _ user: UserModel,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func fetchUser(
        uid: String,
        completion: @escaping (Result<UserModel, Error>) -> Void
    )

    func updateUser(
        _ user: UserModel,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class UserService: UserServiceProtocol {

    private let db = Firestore.firestore()

    func createUser(
        _ user: UserModel,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        do {
            try db.collection("users")
                .document(user.id)
                .setData(from: user) { error in

                    if let error {
                        completion(.failure(error))
                        return
                    }

                    completion(.success(()))
                }

        } catch {
            completion(.failure(error))
        }
    }

    func fetchUser(
        uid: String,
        completion: @escaping (Result<UserModel, Error>) -> Void
    ) {

        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot, snapshot.exists else {
                    completion(.failure(UserError.userNotFound))
                    return
                }

                do {
                    let user = try snapshot.data(as: UserModel.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
    }

    func updateUser(
        _ user: UserModel,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        do {
            try db.collection("users")
                .document(user.id)
                .setData(from: user) { error in

                    if let error {
                        completion(.failure(error))
                        return
                    }

                    completion(.success(()))
                }

        } catch {
            completion(.failure(error))
        }
    }
}
