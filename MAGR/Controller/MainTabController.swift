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
    /*
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let announcementVC = AnnouncementVC()
        announcementVC.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone"), tag: 0)

        let prayerVc = PrayerTimeHomeVC()
        announcementVC.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone"), tag: 0)

        let homeVc = HomeVC()
        announcementVC.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone"), tag: 0)
        
        let settingsVc = SettingsVC()
        announcementVC.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone"), tag: 0)
        
        viewControllers = [announcementVC, prayerVc, homeVc, settingsVc]
        
    }
     */
}
