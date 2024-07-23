// CoreDataHelper.swift
// Add quantity to CartItem

//  CoreDataHelper.swift
//  Ecommerce

import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.context
    }
    
    // MARK: - Category Operations
    
    func saveCategory(id: Int, name: String) -> CategoryEntity {
        let category = CategoryEntity(context: context)
        category.id = Int64(id)
        category.name = name
        saveContext()
        return category
    }
    
    
    func fetchCategories() -> [CategoryEntity] {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    // MARK: - Product Operations
    
    func saveProduct(id: Int, name: String, icon: String, price: Double, category: CategoryEntity) {
        let product = ProductEntity(context: context)
        product.id = Int64(id)
        product.name = name
        product.icon = icon
        product.price = price
        product.category = category
        
        saveContext()
    }
    
    func fetchProducts(for category: CategoryEntity) -> [ProductEntity] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    // MARK: - Cart Operations
    
    func addToCart(product: ProductEntity, quantity: Int) {
        let cartItems = fetchCartItems()
        if let existingCartItem = cartItems.first(where: { $0.product == product }) {
            existingCartItem.quantity += Int64(quantity)
        } else {
            let newCartItem = CartItem(context: context)
            newCartItem.product = product
            newCartItem.quantity = Int64(quantity)
        }
        saveContext()
    }
    
    
    func getCartItemCount() -> Int {
        let cartItems = fetchCartItems()
        return cartItems.reduce(0) { $0 + Int($1.quantity) }
    }
    
    func fetchCartItems() -> [CartItem] {
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch cart items: \(error)")
            return []
        }
    }
    
    func removeFromCart(cartItem: CartItem) {
        context.delete(cartItem)
        saveContext()
    }
    
    func clearCart() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch let error as NSError {
            print("Could not clear cart. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Favorite Operations
    
    func addToFavorites(product: ProductEntity) {
        let favoriteItem = FavoriteItem(context: context)
        favoriteItem.product = product
        
        saveContext()
    }
    
    func fetchFavoriteItems() -> [FavoriteItem] {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite items: \(error)")
            return []
        }
    }
    
    func removeFromFavorites(favoriteItem: FavoriteItem) {
        context.delete(favoriteItem)
        saveContext()
    }
    
    // MARK: - Save Context
    
     func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
