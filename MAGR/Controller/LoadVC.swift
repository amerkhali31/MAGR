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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        appDelegate.delegate = self
        setupScreen()
        
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
extension LoadVC: appDelegateDelegate {
    
    func prepareApp() {
        
        
        let _ = DataManager.getDateofLastNetwork()
        let _ = DataManager.getHadithNumber()
        
        
        do {
            
            // Load From Memory
            try DataManager.loadMonthlyPrayerEntities()
            try DataManager.loadDailyPrayerEntities()
            try DataManager.loadNotificationEntities()
        
            // Get the date before networking in case we need todays date for data processing
            DataManager.setTodaysDate(TimeManager.getTodaysDate())
            
            Task {
                async let hadithNumber = FirebaseManager.fetchHadithNumber()
                async let announcements: () = DataManager.handleAnnouncements()
                async let monthly: () = DataManager.handleMonthly()
                async let token = try appDelegate.fetchFCMToken()
                
                let fcmToken = try await token
                DataManager.device_token = fcmToken
                
                let userPreferences = try await FirebaseManager.fetchUserPreferences(for: fcmToken)
                DataManager.setUserNotificationPreferences(userPreferences)
                
                await announcements
                await monthly
                await DataManager.setHadithNumber(hadithNumber)
                await DataManager.handleDaily()
                
                // Once Prayer times are gotten, assign current and next prayer
                DataManager.setCurrentPrayer(PrayerManager.findCurrentPrayer())
                DataManager.setNextPrayer(PrayerManager.getNextPrayer())
                
                // With updated times, schedule notifications
                NotificationManager.scheduleAllDailyNotifications()
                
                // Go into the actual app
                DispatchQueue.main.async {
                    DataManager.printFilteredUserDefaults()
                    self.performSegue(withIdentifier: K.segues.loadSeque, sender: self)
                }
            }
            
        }
        catch {print("Error Preparing App: \(error)")}
        
    }
    
    func clearAll() {
        DataManager.clearCoreData()
        DataManager.clearUserDefaults()
    }
    
}
