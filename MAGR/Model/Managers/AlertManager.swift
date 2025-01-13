//
//  AlertManager.swift
//  MAGR
//
//  Created by Amer Khalil on 1/13/25.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private var alertQueue: [UIAlertController] = []
    private var isPresenting = false
    
    private init() {}
    
    /// Add an alert to the queue
    func addAlert(_ alert: UIAlertController) {
        alertQueue.append(alert)
        showNextAlert()
    }
    
    /// Present the next alert in the queue
    private func showNextAlert() {
        guard !isPresenting, !alertQueue.isEmpty else { return }
        
        isPresenting = true
        let alert = alertQueue.removeFirst()
        
        DispatchQueue.main.async {
            if let rootVC = self.getKeyWindow()?.rootViewController {
                self.getTopViewController(from: rootVC)?.present(alert, animated: true) {
                    self.isPresenting = false
                    self.showNextAlert()
                }
            } else {
                self.isPresenting = false
                self.showNextAlert() // Ensure subsequent alerts still get a chance to show
            }
        }
    }
    
    /// Recursively find the top-most view controller
    private func getTopViewController(from root: UIViewController) -> UIViewController? {
        if let presented = root.presentedViewController {
            return getTopViewController(from: presented)
        }
        if let nav = root as? UINavigationController {
            return nav.visibleViewController
        }
        if let tab = root as? UITabBarController {
            return tab.selectedViewController
        }
        return root
    }

    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            // Use UIWindowScene to get the key window
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            // Fallback for earlier iOS versions
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }

}
