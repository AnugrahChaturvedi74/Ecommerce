//
//  FavouriteVC.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit

class FavouriteVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var favoriteItems: [FavoriteItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        favoriteItems = CoreDataHelper.shared.fetchFavoriteItems()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FavouriteItemCell", bundle: nil), forCellReuseIdentifier: "FavouriteItemCell")
        tableView.tableFooterView = UIView()
    }

    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavouriteVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favoriteItems.count == 0 {
            tableView.setEmptyMessage("No Favorite Items Found")
        } else {
            tableView.restore()
        }
        return favoriteItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteItemCell.identifier, for: indexPath) as? FavouriteItemCell else {
            return UITableViewCell()
        }
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedView
        let favoriteItem = favoriteItems[indexPath.row]
        if let product = favoriteItem.product {
            cell.configure(with: product)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

