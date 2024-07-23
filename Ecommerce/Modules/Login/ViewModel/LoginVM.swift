//
//  LoginVM.swift
//  Ecommerce
//
//  Created by Anugrah on 22/07/24.
//

class LoginVM {
    
    struct OnboardingScreens {
        let title: String
        let subTitle: String
        let image: String
        
        init(title: String, subTitle: String, image: String) {
            self.title = title
            self.subTitle = subTitle
            self.image = image
        }
    }
    
    func onboardingScreen() -> [OnboardingScreens] {
        return [
            OnboardingScreens(title: "Welcome to", subTitle: "EcommerceApp", image: "screen1"),
            OnboardingScreens(title: "Easy To Use", subTitle: "Your one Stop Destination", image: "screen2")
        ]
    }
    
}

