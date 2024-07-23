//
//  CartCell.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit
import SDWebImage

class CartCell: UITableViewCell {
    
    static let identifier = "CartCell"
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    private var cartItem: CartItem?
    private var updateQuantityCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCell() {
        bgView.layer.cornerRadius = 10
        plusBtn.layer.cornerRadius = 5
        minusBtn.layer.cornerRadius = 5
        plusBtn.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusBtn.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    func configure(with cartItem: CartItem, updateQuantityCallback: @escaping () -> Void) {
        self.cartItem = cartItem
        self.updateQuantityCallback = updateQuantityCallback
        title.text = cartItem.product?.name
        subtitle.text = "₹ \(cartItem.product?.price ?? 0.0)"
        productQuantity.text = "\(cartItem.quantity)"
        if let iconURL = URL(string: cartItem.product?.icon ?? "") {
            SDWebImageDownloader.shared.downloadImage(with: iconURL, options: [], progress: nil) { [weak self] (image, _, error, _) in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                guard let image = image else {
                    print("Image is nil")
                    return
                }
                self?.img.image = image
            }
        }
        
    }
    
    @objc private func plusButtonTapped() {
        guard let cartItem = cartItem else { return }
        cartItem.quantity += 1
        CoreDataHelper.shared.saveContext()
        productQuantity.text = "\(cartItem.quantity)"
        updateQuantityCallback?()
    }
    
    @objc private func minusButtonTapped() {
        guard let cartItem = cartItem else { return }
        if cartItem.quantity > 1 {
            cartItem.quantity -= 1
            CoreDataHelper.shared.saveContext()
            productQuantity.text = "\(cartItem.quantity)"
            updateQuantityCallback?()
        } else {
            cartItem.quantity -= 1
            CoreDataHelper.shared.removeFromCart(cartItem: cartItem)
            updateQuantityCallback?()
        }
    }
}
