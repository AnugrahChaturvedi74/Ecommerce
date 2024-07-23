//
//  CartItem+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var quantity: Int64
    @NSManaged public var product: ProductEntity?

}

extension CartItem : Identifiable {

}
