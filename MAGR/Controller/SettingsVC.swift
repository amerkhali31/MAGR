//
//  SettingsVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class SettingsVC: BaseBackgroundViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the label above the imageView
        let titleLabel = UILabel()
        titleLabel.text = "Notification Settings"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        // Add the central image view
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PrayerBackground") // Replace with your image
        imageView.contentMode = .scaleAspectFill // Fill the imageView while maintaining aspect ratio
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white // Set background color
        imageView.isUserInteractionEnabled = true // Enable interaction for UIImageView
        
        // Style the imageView with rounded corners, shadow, and border
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true // Ensure the image respects rounded corners
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        view.addSubview(imageView)
        
        // Define the names of the prayers
        let prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
        var previousView: UIView? = nil
        
        // Create label-switch pairs for the prayers
        for (index, prayer) in prayers.enumerated() {
            let (container, _) = createLabelSwitchPair(
                labelText: prayer,
                switchName: "\(prayer.lowercased())Switch",
                tag: index
            )
            imageView.addSubview(container)
            
            // Add constraints for each pair
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
                container.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
                container.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let previous = previousView {
                // Position below the previous pair
                NSLayoutConstraint.activate([
                    container.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 15)
                ])
            } else {
                // First pair: position at the top of the imageView
                NSLayoutConstraint.activate([
                    container.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20)
                ])
            }
            
            previousView = container
        }
        
        // Add constraints to the imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.bottomAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 20)
        ])
        
        // Add constraints to the title label
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Function to create a label-switch pair inside a horizontal container
    private func createLabelSwitchPair(labelText: String, switchName: String, tag: Int) -> (UIView, UISwitch) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Create label
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Create switch
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.accessibilityIdentifier = switchName // Name the switch in camel case
        switchControl.tag = tag // Assign tag to the switch
        //switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // Add label and switch to the container
        container.addSubview(label)
        container.addSubview(switchControl)
        
        // Add constraints for the label and switch
        NSLayoutConstraint.activate([
            // Label constraints
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Switch constraints
            switchControl.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            switchControl.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Ensure tighter spacing between label and switch
            label.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -5)
        ])
        
        return (container, switchControl)
    }
    

    /*
    @objc func switchValueChanged(_ sender: UISwitch) {
        // Update the user preference for notifications
        let allSwitches = view.subviews.compactMap { ($0 as? UIImageView)?.subviews.compactMap { $0 as? UISwitch } }.flatMap { $0 }
        let anySwitchOn = allSwitches.contains { $0.isOn }
        DataManager.setUserWantsNotifications(anySwitchOn)
        
        // Prayer names, notification keys, and times mapped to tags
        let prayerData: [Int: (name: String, notification: String, time: String)] = [
            0: (K.FireStore.dailyPrayers.names.fajr, K.AdhanNotifications.fajrNotice, DataManager.getFajrToday().adhan),
            1: (K.FireStore.dailyPrayers.names.dhuhr, K.AdhanNotifications.dhuhrNotice, DataManager.getDhuhrToday().adhan),
            2: (K.FireStore.dailyPrayers.names.asr, K.AdhanNotifications.asrNotice, DataManager.getAsrToday().adhan),
            3: (K.FireStore.dailyPrayers.names.maghrib, K.AdhanNotifications.maghribNotice, DataManager.getMaghribToday().adhan),
            4: (K.FireStore.dailyPrayers.names.isha, K.AdhanNotifications.ishaNotice, DataManager.getIshaToday().adhan)
        ]
        
        // Ensure the tag corresponds to the correct prayer
        guard let currentPrayer = prayerData[sender.tag] else {
            print("Index out of range")
            return
        }
        
        // Update the notification entity status
        DataManager.NotificationEntities[currentPrayer.name]?.status = sender.isOn
        
        // Remove existing notification
        NotificationManager.deleteNotification(currentPrayer.notification)
        
        // Schedule new notification if the switch is ON
        if sender.isOn {
            print("\(currentPrayer.name) notification switch is on")
            let date = TimeManager.createDateFromTime(currentPrayer.time)
            NotificationManager.scheduleNotification(at: date, currentPrayer.name, currentPrayer.notification)
        }
        
        // Print scheduled notifications and save database
        NotificationManager.printScheduledNotifications()
        DataManager.saveDatabase()
    }
     */
}





/*
@objc func switchValueChanged(_ sender: UISwitch) {
     
     if fajrSwitch.isOn || zuhrSwitch.isOn || asrSwitch.isOn || maghribSwitch.isOn || ishaSwitch.isOn {
         DataManager.defaults.set(true, forKey: K.userDefaults.userWantsNotitifications)
     }
     else { DataManager.defaults.set(false, forKey: K.userDefaults.userWantsNotitifications) }
     
     switch sender.tag {
         
     case 0:
         
         DataManager.NotificationEntities[K.FireStore.dailyPrayers.names.fajr]?.status = fajrSwitch.isOn
         NotificationManager.deleteNotification(K.AdhanNotifications.fajrNotice)
         if fajrSwitch.isOn {
             print("Fajr notification switch is on")
             let date = TimeManager.createDateFromTime(DataManager.fajrTodayAdhan)
             NotificationManager.scheduleNotification(at: date, "Fajr", K.AdhanNotifications.fajrNotice)
         }
         
     case 1:
         
         DataManager.NotificationEntities[K.FireStore.dailyPrayers.names.dhuhr]?.status = zuhrSwitch.isOn
         NotificationManager.deleteNotification(K.AdhanNotifications.dhuhrNotice)
         if zuhrSwitch.isOn {
             let date = TimeManager.createDateFromTime(DataManager.dhuhrTodayAdhan)
             NotificationManager.scheduleNotification(at: date, "Zuhr", K.AdhanNotifications.dhuhrNotice)
         }
         
     case 2:
         DataManager.NotificationEntities[K.FireStore.dailyPrayers.names.asr]?.status = asrSwitch.isOn
         NotificationManager.deleteNotification(K.AdhanNotifications.asrNotice)
         if asrSwitch.isOn {
             let date = TimeManager.createDateFromTime(DataManager.asrTodayAdhan)
             NotificationManager.scheduleNotification(at: date, "Asr", K.AdhanNotifications.asrNotice)
         }
         
     case 3:
         DataManager.NotificationEntities[K.FireStore.dailyPrayers.names.maghrib]?.status = maghribSwitch.isOn
         NotificationManager.deleteNotification(K.AdhanNotifications.maghribNotice)
         if maghribSwitch.isOn {
             let date = TimeManager.createDateFromTime(DataManager.maghribTodayAdhan)
             NotificationManager.scheduleNotification(at: date, "Maghrib", K.AdhanNotifications.maghribNotice)
         }
         
     case 4:
         DataManager.NotificationEntities[K.FireStore.dailyPrayers.names.isha]?.status = ishaSwitch.isOn
         NotificationManager.deleteNotification(K.AdhanNotifications.ishaNotice)
         if ishaSwitch.isOn {
             let date = TimeManager.createDateFromTime(DataManager.ishaTodayAdhan)
             NotificationManager.scheduleNotification(at: date, "Isha", K.AdhanNotifications.ishaNotice)
         }
         
     default: print("Index out of range")
     }
     
     NotificationManager.printScheduledNotifications()
     DataManager.saveDatabase()
 }
*/

