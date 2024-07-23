//
//  UIWindow+Extension.swift
//  Ecommerce
//
//  Created by Anugrah on 23/07/24.
//

import UIKit
import Toast_Swift

extension UIWindow {

    static func getWindowForToast() -> UIWindow? {
        if #available(iOS 13.0, *) {
            // Get the key window scene
            if let windowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first {
                return windowScene.windows.first
            }
        } else {
            // For iOS versions prior to 13, fall back to the key window
            return UIApplication.shared.keyWindow
        }
        return nil
    }

    func showToast(message: String) {
        let toastStyle = ToastStyle()
        self.makeToast(message, duration: 2.0, position: .bottom, style: toastStyle)
    }
}

extension UIViewController {
    func showToast(message: String) {
        if let window = UIWindow.getWindowForToast() {
            window.showToast(message: message)
        }
    }
}
