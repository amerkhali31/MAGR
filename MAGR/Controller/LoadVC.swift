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
    func setupScreen() {
        
        loadingImageView.image = loadingImage
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .MAGR_4
        view.addSubview(loadingImageView)
        
        spinner.center = view.center
        spinner.startAnimating()
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loadingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loadingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            loadingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            spinner.topAnchor.constraint(equalTo: loadingImageView.bottomAnchor, constant: 0),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

//MARK: Prepare the app by loading and networking. In Progress
extension LoadVC {
    
    func prepareApp() {
        do {
            try DataManager.loadMonthlyPrayerEntities()
            try DataManager.loadDailyPrayerEntities()
            try DataManager.loadNotificationEntities()
            
            DataManager.setTodaysDate(TimeManager.getTodaysDate())
            
            Task {
                async let announcements: () = DataManager.handleAnnouncements()
                async let monthly: () = DataManager.handleMonthly()
                
                await announcements
                await monthly
                
                await DataManager.handleDaily()
                
                print(DataManager.getFajrToday())
            }
            
        }
        catch {print("Error Preparing App: \(error)")}
        
    }
    
}
