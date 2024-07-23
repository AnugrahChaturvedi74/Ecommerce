//
//  ProductEntity+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var category: CategoryEntity?

}

extension ProductEntity : Identifiable {

}
