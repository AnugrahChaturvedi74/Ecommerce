//
//  FavouriteItemCell.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit
import SDWebImage

class FavouriteItemCell: UITableViewCell {

    static let identifier = "FavouriteItemCell"

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var favPriceLabel: UILabel!
    @IBOutlet weak var favTitleLabel: UILabel!
    @IBOutlet weak var favImgView: UIImageView!

    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }


    private func setupCell() {
 
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.1
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 4
    }

    func configure(with product: ProductEntity) {
        favTitleLabel.text = product.name
        favPriceLabel.text = "₹ \(product.price)"
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
                self?.favImgView.image = image
            }
            
        }
    }
}
