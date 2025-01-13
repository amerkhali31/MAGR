//
//  SettingsViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 1/12/25.
//

import UIKit

class SettingsViewController: BaseBackgroundViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

    }
}

// MARK: Setup View
extension SettingsViewController {
    
    func setupView() {
        
        let settingsLabel = UILabel()
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.text = "Notification Preferences"
        settingsLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .center
        self.view.addSubview(settingsLabel)
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: bottomOfImage + 10),
            settingsLabel.heightAnchor.constraint(equalToConstant: 42),
            settingsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            settingsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
            
        ])
        
        
        let fajrView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.fajr)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.fajr).")
        fajrView.attachTo(parentView: self.view, topAnchor: settingsLabel.bottomAnchor, topInset: 10)
        fajrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.fajrToday)}
        
        let dhuhrView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.dhuhr)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.dhuhr).")
        dhuhrView.attachTo(parentView: self.view, topAnchor: fajrView.bottomAnchor)
        dhuhrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.dhuhrToday)}
        
        let asrView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.asr)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.asr).")
        asrView.attachTo(parentView: self.view, topAnchor: dhuhrView.bottomAnchor)
        asrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.asrToday)}
        
        let maghribView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.maghrib)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.maghrib).")
        maghribView.attachTo(parentView: self.view, topAnchor: asrView.bottomAnchor)
        maghribView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.maghribToday)}
        
        let ishaView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.isha)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.isha).")
        ishaView.attachTo(parentView: self.view, topAnchor: maghribView.bottomAnchor)
        ishaView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.ishaToday)}
        
        let jumaaView = SettingsBox(
            title: "\(K.DailyPrayerDisplayNames.jumaa_salah)",
            description: "Set notifications preferences for \(K.DailyPrayerDisplayNames.jumaa_salah).")
        jumaaView.attachTo(parentView: self.view, topAnchor: ishaView.bottomAnchor)
        jumaaView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.khutbaToday)}
        
        let membershipNotice =  SettingsBox(
            title: "Membership Renewal",
            description: "Set notifications preferences for Membership Renewals.")
        membershipNotice.attachTo(parentView: self.view, topAnchor: jumaaView.bottomAnchor)
        membershipNotice.onTouch = {self.otherTouch(touched: 0)}
    }
}

// MARK: Helper Function to create views
extension SettingsViewController {
    
    func otherTouch(touched: Int) {
        if DataManager.notificationsEnabled {
            let otherVC = OtherNotificationViewController()
            var inputs: [String] = []
            
            switch touched {
                case 0: inputs = ["Membership Renewal",K.userDefaults.membership_renewal]
                default: print()
            }
            
            otherVC.inputs = inputs
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(otherVC, animated: true)
            }
            
        }
        else {
            let alert = UIAlertController(
                title: "Enable Notifications",
                message: "Please enable notifications in your device settings nad restart the app to use this feature.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
        
    func prayerTouch(dailyPrayer: DailyPrayer) {
        
        if DataManager.notificationsEnabled {
            
            let prayerVC = PrayerNoticeViewController()
            var inputs: [String] = []
            var is_jumaa = false
            switch dailyPrayer.name {
                case K.DailyPrayerDisplayNames.fajr: inputs = [dailyPrayer.name,K.userDefaults.fajr_adhan_notification, K.userDefaults.fajr_iqama_notification]
                case K.DailyPrayerDisplayNames.dhuhr: inputs = [dailyPrayer.name,K.userDefaults.dhuhr_adhan_notification, K.userDefaults.dhuhr_iqama_notification]
                case K.DailyPrayerDisplayNames.asr: inputs = [dailyPrayer.name,K.userDefaults.asr_adhan_notification, K.userDefaults.asr_iqama_notification]
                case K.DailyPrayerDisplayNames.maghrib: inputs = [dailyPrayer.name,K.userDefaults.maghrib_adhan_notification, K.userDefaults.maghrib_iqama_notification]
                case K.DailyPrayerDisplayNames.isha: inputs = [dailyPrayer.name,K.userDefaults.isha_adhan_notification, K.userDefaults.isha_iqama_notification]
                case K.DailyPrayerDisplayNames.jumaa_khutba:
                    inputs = [dailyPrayer.name,K.userDefaults.jumaa_khutba, K.userDefaults.jumaa_salah]
                    is_jumaa = true
                
                default: print()
            }
            
            prayerVC.inputs = inputs
            prayerVC.is_jumaa = is_jumaa
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(prayerVC, animated: true)
            }
            
        }
        else {
            let alert = UIAlertController(
                title: "Enable Notifications",
                message: "Please enable notifications in your device settings nad restart the app to use this feature.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}

