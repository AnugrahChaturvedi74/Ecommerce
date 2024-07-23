//
//  CartVC.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit

class CartVC: UIViewController, PaymentDelegate {
    
    @IBOutlet weak var checkoutLbl: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var footerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var cartItems: [CartItem] = []

    @IBOutlet weak var priceBreakUp: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartItems = CoreDataHelper.shared.fetchCartItems()
        setupTableView()
        updateFooterView()
        checkoutLbl.layer.cornerRadius = 10
        priceBreakUp.layer.cornerRadius = 10
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.tableFooterView = UIView()
    }

    func didDismissAlert() {
        CoreDataHelper.shared.clearCart()
        cartItems.removeAll()
        tableView.reloadData()
        updateFooterView()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    private func updateCartItems() {
        cartItems = CoreDataHelper.shared.fetchCartItems()
        tableView.reloadData()
        updateFooterView()
    }

    private func removeCartItem(at indexPath: IndexPath) {
        let cartItem = cartItems[indexPath.row]
        CoreDataHelper.shared.removeFromCart(cartItem: cartItem)
        cartItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateFooterView()
    }

    private func updateFooterView() {
        let hasItems = !cartItems.isEmpty
        footerViewHeight.constant = hasItems ? 200 : 0
        footerView.isHidden = !hasItems

        let subtotal = cartItems.reduce(0) { $0 + Double($1.quantity) * ($1.product?.price ?? 0) }
        let total = subtotal 

        subtotalLbl.text = String(format: "₹%.2f", subtotal)
        totalLbl.text = String(format: "₹%.2f", total)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func didTapCheckout(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc: PaymentVC = (storyBoard.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC)!
        vc.paymentDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension CartVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem) { [weak self] in
            if cartItem.quantity == 0 {
                self?.removeCartItem(at: indexPath)
            } else {
                self?.updateCartItems()
            }
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
