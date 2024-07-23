//
//  DashboardCell.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import UIKit

protocol DashboardCellDelegate: AnyObject {
    func didTapAddToCart(for product: ProductEntity, quantity: Int)
}

class DashboardCell: UITableViewCell {

    static let identifier = "DashboardCell"

    let collectionView: UICollectionView
    var products: [ProductEntity] = []
    weak var delegate: DashboardCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 220)
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "blue")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionCell.identifier)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    func configure(with products: [ProductEntity]) {
        self.products = products
        collectionView.reloadData()
    }
}

extension DashboardCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.item]
        cell.configure(with: product)
        cell.delegate = self
        return cell
    }
    
}

extension DashboardCell: CollectionCellDelegate {
    func didTapAddToCart(for product: ProductEntity, quantity: Int) {
        delegate?.didTapAddToCart(for: product, quantity: quantity)
    }

}
