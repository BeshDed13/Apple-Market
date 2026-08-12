//
//  FavoriteProduct+CoreDataProperties.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import CoreData

extension FavoriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
        NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
    }

    @NSManaged public var id: String?
}
