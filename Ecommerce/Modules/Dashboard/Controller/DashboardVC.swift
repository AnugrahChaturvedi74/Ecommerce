//  DashboardVC.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartItemCountLbl: UILabel!

    var sectionStates: [Bool] = []
    var categories: [CategoryEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        // Check if it's the first time login
        let isFirstTimeLoginKey = "isFirstTimeLogin"
        let isFirstTimeLogin = UserDefaults.standard.bool(forKey: isFirstTimeLoginKey)
        
        if isFirstTimeLogin {
            initialLoadCategoryData()
        }
        cartItemCountLbl.layer.cornerRadius = 7.5
        cartItemCountLbl.clipsToBounds = true
        loadCategoryData()
        updateCartItemCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartItemCount()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.bounces = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(DashboardCell.self, forCellReuseIdentifier: DashboardCell.identifier)
    }
    
    private func initialLoadCategoryData() {
        if let loadedCategories = loadCategories(from: "shopping") {
            for category in loadedCategories {
                let categoryEntity = CoreDataHelper.shared.saveCategory(id: category.id, name: category.name)
                for product in category.items {
                    CoreDataHelper.shared.saveProduct(id: product.id, name: product.name, icon: product.icon, price: product.price, category: categoryEntity)
                }
            }
        } else {
            print("Failed to load categories from JSON")
        }
    }
    
    private func loadCategoryData() {
        self.categories = CoreDataHelper.shared.fetchCategories()
        sectionStates = Array(repeating: true, count: categories.count)
        tableView.reloadData()
    }
    
    private func loadCategories(from fileName: String) -> [Category]? {
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
    
    private func updateCartItemCount() {
        let itemCount = CoreDataHelper.shared.getCartItemCount()
        if itemCount > 0 {
            cartItemCountLbl.isHidden = false
            cartItemCountLbl.text = "\(itemCount)"
        } else {
            cartItemCountLbl.isHidden = true
        }
    }
    
    @IBAction func didTapFavBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc: FavouriteVC = (storyBoard.instantiateViewController(withIdentifier: "FavouriteVC") as? FavouriteVC)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapCartBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc: CartVC = (storyBoard.instantiateViewController(withIdentifier: "CartVC") as? CartVC)!
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionStates[section] ? 1 : 0 // One row per section
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifier, for: indexPath) as? DashboardCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.section]
        if let productsSet = category.products as? Set<ProductEntity> {
            let products = Array(productsSet)
            cell.configure(with: products)
        }
        
        cell.delegate = self
        
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.section), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            cell.transform = .identity
        }, completion: nil)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create header view
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "blue")

  
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = categories[section].name
        label.textColor = .label
        headerView.addSubview(label)

        let arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.down")
        arrowImageView.tintColor = .label
        headerView.addSubview(arrowImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
  
        let isExpanded = sectionStates[section]
        arrowImageView.image = UIImage(systemName: isExpanded ? "chevron.up" : "chevron.down")

        return headerView
    }

    @objc private func handleHeaderTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        
        sectionStates[section] = !(sectionStates[section])
    
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension DashboardVC: DashboardCellDelegate {
    func didTapFavButton(for product: ProductEntity) {
        if let name = product.name {
            showToast(message: "\(name) is Marked as Favourite")
        }
    }
    
    func didTapAddToCart(for product: ProductEntity, quantity: Int) {
        CoreDataHelper.shared.addToCart(product: product, quantity: quantity)
        if let name = product.name {
            showToast(message: "\(name) is Added to Cart")
        }
        updateCartItemCount()
    }
    
}
