//
//  MainTabController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

/**
 The main view of the app. Holds all of the tabs
 
 - Note: Only access for deciding which page to be on

 */
class MainTabController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {self.selectedIndex = 1}

}
