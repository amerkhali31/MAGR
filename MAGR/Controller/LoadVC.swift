//
//  LoadVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class LoadVC: UIViewController {
    
    let loadingImageView = UIImageView()
    let loadingImage = UIImage(named: K.images.logo)
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        
        setupScreen()
        prepareApp()
        
        super.viewDidLoad()
    }
}

//MARK: Set up the screen - Tested and functional.
extension LoadVC {
    
    /// Spinner, background color, and logo on the screen
    private func setupScreen() {
        
        loadingImageView.image = loadingImage
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .MAGR_5
        view.addSubview(loadingImageView)
        
        spinner.center = view.center
        spinner.startAnimating()
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loadingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loadingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            loadingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            spinner.topAnchor.constraint(equalTo: loadingImageView.bottomAnchor, constant: 0),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

//MARK: Prepare the app by loading and networking. In Progress
extension LoadVC {
    
    func prepareApp() {
        
        // Load from UserDefaults
        DataManager.getDateofLastNetwork()
        DataManager.getHadithNumber()
        DataManager.loadUserNotificationPreferences()
            
        // Load From Core Data
        DataManager.loadMonthlyPrayerEntities()
        DataManager.loadTodayPrayerEntities()
        DataManager.loadAnnouncementEntities()
    
        // Get the date before networking in case we need todays date for data processing
        DataManager.todaysDate = TimeManager.getTodaysDate()
        
        Task {
            
            // Network if needed or move on with loaded data
            async let hadithNumber: () = DataManager.handleHadith()
            async let announcements: () = DataManager.handleAnnouncements()
            async let monthly: () = DataManager.handleMonthly()
            async let daily: () = DataManager.handleDaily()

            await announcements
            await monthly
            await hadithNumber
            await daily
            
            DataManager.currentPrayer = PrayerManager.findCurrentPrayer()
            DataManager.nextPrayer = PrayerManager.getNextPrayer()

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.segues.loadSeque, sender: self)
            }
        }
    }
    
    func clearAll() {
        DataManager.clearCoreData()
        DataManager.clearUserDefaults()
    }
    
}
