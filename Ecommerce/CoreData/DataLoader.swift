//
//  DataLoader.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import Foundation

class DataLoader {
    static func loadCategories(from fileName: String) -> [Category]? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(CategoriesResponse.self, from: data)
            return response.categories
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
