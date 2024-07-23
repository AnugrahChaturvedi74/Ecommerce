//
//  FavoriteItem+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//
//

import Foundation
import CoreData


extension FavoriteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItem> {
        return NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var product: ProductEntity?

}

extension FavoriteItem : Identifiable {

}
