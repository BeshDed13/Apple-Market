//
//  ImageLoader.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 09.08.2026.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(
        from urlString: String,
        completion: @escaping (UIImage?) -> Void
    )
}

final class ImageLoader: ImageLoaderProtocol {

    private let cache = NSCache<NSString, UIImage>()

    func loadImage(
        from urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let cachedImage = cache.object(
            forKey: urlString as NSString
        ) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            guard
                error == nil,
                let data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self?.cache.setObject(
                image,
                forKey: urlString as NSString
            )

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
