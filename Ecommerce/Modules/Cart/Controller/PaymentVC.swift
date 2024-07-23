//
//  PaymentVC.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit

protocol PaymentDelegate: AnyObject {
    func didDismissAlert()
}


class PaymentVC: UIViewController {
    
    @IBOutlet weak var alertMesage: UILabel!
    @IBOutlet weak var alertImg: UIImageView!
    @IBOutlet weak var alertView: UIView!
   
    weak var paymentDelegate : PaymentDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
        alertMesage.text = "Order Successful"
        alertImg.image = UIImage(named: "checked")
    }
    
 
    @IBAction func didDismissBtnTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        paymentDelegate?.didDismissAlert()
    }
    

}
