//
//  CollectionCell.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import UIKit
import SDWebImage
import Lottie

protocol CollectionCellDelegate: AnyObject {
    func didTapAddToCart(for product: ProductEntity, quantity: Int)
    func didTapFavButton(for product: ProductEntity )
}

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var productSubtitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImg: UIImageView!

    static let identifier = "CollectionCell"

    private var product: ProductEntity?
    private var quantity: Int = 1
    weak var delegate: CollectionCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        favouriteBtn.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        plusBtn.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }

    func configure(with product: ProductEntity) {
        self.product = product
        productTitle.text = product.name
        productSubtitle.text = "₹ \(product.price)"
        if let iconURL = URL(string: product.icon ?? "") {
            SDWebImageDownloader.shared.downloadImage(with: iconURL, options: [], progress: nil) { [weak self] (image, _, error, _) in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let image = image else {
                    print("Image is nil")
                    return
                }
                self?.productImg.image = image
            }
            
        }
        let isFavorite = CoreDataHelper.shared.fetchFavoriteItems().contains { $0.product == product }
        let heartImageName = isFavorite ? "heart.fill" : "heart"
        favouriteBtn.setImage(UIImage(systemName: heartImageName), for: .normal)
        favouriteBtn.tintColor = .red
    }

    private func setupCell() {
        plusBtn.layer.cornerRadius = 4
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.1
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 4
        bgView.layoutIfNeeded()
    }

    @objc private func favoriteButtonTapped() {
        guard let product = product else { return }
        let isFavorite = CoreDataHelper.shared.fetchFavoriteItems().contains { $0.product == product }
        if (isFavorite) {
            if let favoriteItem = CoreDataHelper.shared.fetchFavoriteItems().first(where: { $0.product == product }) {
                CoreDataHelper.shared.removeFromFavorites(favoriteItem: favoriteItem)
                favouriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        } else {
            CoreDataHelper.shared.addToFavorites(product: product)
            favouriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            delegate?.didTapFavButton(for: product)
        }
    }

    @objc private func addToCartButtonTapped() {
        guard let product = product else { return }
        delegate?.didTapAddToCart(for: product, quantity: quantity)
    }
}

