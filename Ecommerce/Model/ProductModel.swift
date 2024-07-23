//
//  ProductModel.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let icon: String
    let price: Double
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let items: [Product]
}

// MARK: - Response
struct CategoriesResponse: Codable {
    let status: Bool
    let message: String
    let error: String?
    let categories: [Category]
}

