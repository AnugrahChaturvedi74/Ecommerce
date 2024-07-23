//
//  SplashVC.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit

class SplashVC: UIViewController {

    private let isFirstTimeLoginKey = "isFirstTimeLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        if keyExists(key: isFirstTimeLoginKey) {
            UserDefaults.standard.setValue(false, forKey: isFirstTimeLoginKey)
        }
        else{
            UserDefaults.standard.setValue(true, forKey: isFirstTimeLoginKey)
        }
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let vc: LoginVC = (storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
        navigationController?.pushViewController(vc, animated: true)
    }
    func keyExists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
