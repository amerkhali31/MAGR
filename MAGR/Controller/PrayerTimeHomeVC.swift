//
//  PrayerTimeHomeVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

import UIKit

class PrayerTimeHomeVC: BaseBackgroundViewController {
    
    let todayView = UIView()
    let monthView = UIView()
    
    let fajrView = PrayerView()
    let dhuhrView = PrayerView()
    let asrView = PrayerView()
    let maghribView = PrayerView()
    let ishaView = PrayerView()
    let khutbaView = PrayerView()
    let jumaaView = PrayerView()
    
    let dateLabel = UILabel()
    let adhanLabel = UILabel()
    let iqamaLabel = UILabel()
    
    let monthlyDateLabel = UILabel()
    let fajrLabel = UILabel()
    let dhuhrLabel = UILabel()
    let asrLabel = UILabel()
    let maghribLabel = UILabel()
    let ishaLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTodayView()

    }
}

// MARK: - Today View Configuration
extension PrayerTimeHomeVC {
    
    func configureTodayView() {
        // Add `todayView` to the parent view
        todayView.backgroundColor = .clear
        todayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayView)
        
        // Set constraints for `todayView`
        NSLayoutConstraint.activate([
            todayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            todayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            todayView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.bottomOfImage + 10),
            todayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        //Add Content to the view
        setupTopLabels()
        setupPrayerViews()
    }
    
    func setupTopLabels() {
        
        configureLabel(labelToConfigure: dateLabel, text: "Date")
        dateLabel.leadingAnchor.constraint(equalTo: todayView.leadingAnchor, constant: 0).isActive = true

        configureLabel(labelToConfigure: adhanLabel, text: "Adhan")
        adhanLabel.centerXAnchor.constraint(equalTo: todayView.centerXAnchor).isActive = true
        
        configureLabel(labelToConfigure: iqamaLabel, text: "iqama")
        iqamaLabel.trailingAnchor.constraint(equalTo: todayView.trailingAnchor, constant: 0).isActive = true

        
    }
    
    func configureLabel(labelToConfigure label: UILabel, text: String) {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        todayView.addSubview(label)
        
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 60),
            label.heightAnchor.constraint(equalToConstant: 21),
            label.topAnchor.constraint(equalTo: todayView.topAnchor, constant: 0)
        ])
    }
    
    func setupPrayerViews() {
        
        // Add and configure the Fajr view
        fajrView.configure(icon: UIImage(systemName: "moon"), prayer: "Fajr", adhan: "5:49 AM", iqama: "6:00 AM")
        fajrView.attachTo(parentView: todayView, topAnchor: adhanLabel.bottomAnchor, topInset: 10)
        fajrView.layer.borderColor = UIColor.white.cgColor
        
        dhuhrView.configure(icon: UIImage(systemName: "sun.max"), prayer: "Dhuhr", adhan: "5:49 AM", iqama: "6:00 AM")
        dhuhrView.attachTo(parentView: todayView, topAnchor: fajrView.bottomAnchor)
        
        asrView.configure(icon: UIImage(systemName: "sun.min"), prayer: "Asr", adhan: "5:49 AM", iqama: "6:00 AM")
        asrView.attachTo(parentView: todayView, topAnchor: dhuhrView.bottomAnchor)

        maghribView.configure(icon: UIImage(systemName: "sun.horizon"), prayer: "Maghrib", adhan: "5:49 AM", iqama: "6:00 AM")
        maghribView.attachTo(parentView: todayView, topAnchor: asrView.bottomAnchor)
        
        ishaView.configure(icon: UIImage(systemName: "moon"), prayer: "Isha", adhan: "5:49 AM", iqama: "6:00 AM")
        ishaView.attachTo(parentView: todayView, topAnchor: maghribView.bottomAnchor)

        khutbaView.configure(icon: UIImage(systemName: "music.mic"), prayer: "Khutba", adhan: "5:49 AM", iqama: "6:00 AM")
        khutbaView.attachTo(parentView: todayView, topAnchor: ishaView.bottomAnchor, topInset: 50)
        
        jumaaView.configure(icon: UIImage(systemName: "sun.max"), prayer: "Salah", adhan: "5:49 AM", iqama: "6:00 AM")
        jumaaView.attachTo(parentView: todayView, topAnchor: khutbaView.bottomAnchor)
    }
}

// MARK: - Month View Configuration
extension PrayerTimeHomeVC {
    func configureMonthView() {
        // Implementation for month view configuration (if needed)
    }
}
