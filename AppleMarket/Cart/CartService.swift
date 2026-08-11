//
//  CartService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import FirebaseAuth
import FirebaseFirestore

protocol CartServiceProtocol {

    func fetchCart(
        completion: @escaping (Result<[CartItem], Error>) -> Void
    )
    
    func fetchQuantity(
        variantId: String,
        completion: @escaping (Result<Int, Error>) -> Void
    )

    func addToCart(
        productId: String,
        variant: ProductVariant,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func increaseQuantity(
        variant: ProductVariant,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func decreaseQuantity(
        variantId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func removeFromCart(
        variantId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func clearCart(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class CartService: CartServiceProtocol {

    private let db: Firestore
    private let auth: Auth

    init(
        db: Firestore = Firestore.firestore(),
        auth: Auth = Auth.auth()
    ) {
        self.db = db
        self.auth = auth
    }

    private var userId: String? {
        auth.currentUser?.uid
    }

    private func cartReference() throws -> CollectionReference {

        guard let userId else {
            throw CartError.notAuthorized
        }

        return db
            .collection("users")
            .document(userId)
            .collection("cart")
    }

    func fetchCart(
        completion: @escaping (Result<[CartItem], Error>) -> Void
    ) {

        do {
            let reference = try cartReference()

            reference.getDocuments { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                do {
                    let items = try documents.map {
                        try $0.data(as: CartItem.self)
                    }

                    completion(.success(items))

                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchQuantity(
        variantId: String,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {

        do {
            let reference = try cartReference()
                .document(variantId)

            reference.getDocument { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot,
                      snapshot.exists else {
                    completion(.success(0))
                    return
                }

                do {
                    let item = try snapshot.data(
                        as: CartItem.self
                    )

                    completion(.success(item.quantity))

                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }

    func addToCart(
        productId: String,
        variant: ProductVariant,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard let variantId = variant.id else {
            completion(.failure(CartError.invalidVariant))
            return
        }

        guard variant.stock > 0 else {
            completion(.failure(CartError.outOfStock))
            return
        }

        do {
            let reference = try cartReference()
                .document(variantId)

            reference.getDocument { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                do {

                    if let snapshot,
                       snapshot.exists {

                        let item = try snapshot.data(
                            as: CartItem.self
                        )

                        let newQuantity = item.quantity + 1

                        guard newQuantity <= variant.stock else {
                            completion(
                                .failure(CartError.outOfStock)
                            )
                            return
                        }

                        reference.updateData([
                            "quantity": newQuantity
                        ]) { error in

                            if let error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }

                    } else {

                        let item = CartItem(
                            id: variantId,
                            productId: productId,
                            quantity: 1
                        )

                        try reference.setData(
                            from: item
                        ) { error in

                            if let error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }

                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }

    func increaseQuantity(
        variant: ProductVariant,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard let variantId = variant.id else {
            completion(.failure(CartError.invalidVariant))
            return
        }

        do {
            let reference = try cartReference()
                .document(variantId)

            reference.getDocument { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot,
                      snapshot.exists else {

                    completion(
                        .failure(CartError.itemNotFound)
                    )

                    return
                }

                do {

                    let item = try snapshot.data(
                        as: CartItem.self
                    )

                    let newQuantity = item.quantity + 1

                    guard newQuantity <= variant.stock else {
                        completion(
                            .failure(CartError.outOfStock)
                        )
                        return
                    }

                    reference.updateData([
                        "quantity": newQuantity
                    ]) { error in

                        if let error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }

                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }


    func decreaseQuantity(
        variantId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        do {
            let reference = try cartReference()
                .document(variantId)

            reference.getDocument { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot,
                      snapshot.exists else {

                    completion(
                        .failure(CartError.itemNotFound)
                    )

                    return
                }

                do {

                    let item = try snapshot.data(
                        as: CartItem.self
                    )

                    if item.quantity <= 1 {

                        reference.delete { error in

                            if let error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }

                    } else {

                        reference.updateData([
                            "quantity": item.quantity - 1
                        ]) { error in

                            if let error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }

                } catch {
                    completion(.failure(error))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }

    func removeFromCart(
        variantId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        do {
            let reference = try cartReference()
                .document(variantId)

            reference.delete { error in

                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }

        } catch {
            completion(.failure(error))
        }
    }

    func clearCart(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        do {
            let reference = try cartReference()

            reference.getDocuments { [weak self] snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents,
                      !documents.isEmpty else {

                    completion(.success(()))
                    return
                }

                guard let self else {
                    return
                }

                let batch = self.db.batch()

                documents.forEach { document in
                    batch.deleteDocument(document.reference)
                }

                batch.commit { error in

                    if let error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }

        } catch {
            completion(.failure(error))
        }
    }
}
