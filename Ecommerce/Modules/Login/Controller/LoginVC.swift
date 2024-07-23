//
//  LoginVC.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let loginVm = LoginVM()
    var currentImageIndex = 0
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
        updateImageAndLabels(index: 0)
        loginBtn.layer.cornerRadius = 10

    }
    
    //MARK: Button Action
    @IBAction func didTapSignInBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc: DashboardVC = (storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: General Function
    func updateImageAndLabels(index: Int) {
        bgImage.image = UIImage(named: loginVm.onboardingScreen()[index].image)
    }
    
    @objc func changeImage() {
        currentImageIndex += 1
        if currentImageIndex >= loginVm.onboardingScreen().count {
            currentImageIndex = 0
        }
        updateImageAndLabels(index: currentImageIndex)
        pageControl.currentPage = currentImageIndex
    }
    
}


