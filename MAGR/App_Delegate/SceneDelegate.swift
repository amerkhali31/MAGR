//
//  SceneDelegate.swift
//  MAGR
//
//  Created by Amer Khalil on 12/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    /*
     func scene(
     _ scene: UIScene,
     willConnectTo session: UISceneSession,
     options connectionOptions: UIScene.ConnectionOptions
     ) {
     guard let windowScene = (scene as? UIWindowScene) else { return }
     
     // Create a new UIWindow and set the root view controller
     window = UIWindow(windowScene: windowScene)
     window?.rootViewController = LoadVC()
     window?.makeKeyAndVisible()
     }
     */
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        sceneDelegate.checkForUpdates()
    }
    
    func checkForUpdates() {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let bundleID = Bundle.main.bundleIdentifier else {
            return
        }
        
        // Query the App Store API for the latest version
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch app version: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {

                    // Compare the current version with the App Store version
                    if appStoreVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                        DispatchQueue.main.async {
                            print("Need to update")
                            self.notifyUserOfUpdate(appStoreVersion: appStoreVersion)
                        }
                    }
                }
            } catch {
                print("Error parsing app version data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func notifyUserOfUpdate(appStoreVersion: String) {
        guard let rootVC = window?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "Update Available",
            message: "A new version (\(appStoreVersion)) is available.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            // Redirect to the App Store
            if let appStoreURL = URL(string: "https://apps.apple.com/app/id6739609048") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Later", style: .cancel))
        
        AlertManager.shared.addAlert(alert)
    }
    
    private func topViewController(from root: UIViewController) -> UIViewController? {
        if let presented = root.presentedViewController {
            return topViewController(from: presented)
        }
        if let nav = root as? UINavigationController {
            return topViewController(from: nav.visibleViewController ?? nav)
        }
        if let tab = root as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(from: selected)
        }
        return root
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

