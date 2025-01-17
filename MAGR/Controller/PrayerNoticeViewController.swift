//
//  PrayerNoticeViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/24/24.
//

import UIKit
import Firebase

protocol PrayerNoticeViewControllerDelegate {
    func updateAlarmStatus(for prayerName: String, isAdhanEnabled: Bool, isIqamaEnabled: Bool)
}

class PrayerNoticeViewController: BaseBackgroundViewController {
    
    var delegate: PrayerNoticeViewControllerDelegate?
    var prayerName: String = ""
    var adhan_bool: Bool = false
    var iqama_bool: Bool = false
    var adhan_field_name: String = ""
    var iqama_field_name: String = ""
    
    var inputs: [String]?
    var is_jumaa: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notification Settings"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processInputs()
        setupUI()
    }
    
    private func processInputs() {
        
        if let safeInputs = inputs {
            
            prayerName = safeInputs[0]
            adhan_field_name = safeInputs[1]
            iqama_field_name = safeInputs[2]
            
            adhan_bool = DataManager.prayer_notification_preferences[adhan_field_name] ?? false
            iqama_bool = DataManager.prayer_notification_preferences[iqama_field_name] ?? false
        }
    }
    
    private func setupUI() {
        
        // Add the title label
        titleLabel.text = "\(prayerName) Notification Settings"
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and add Adhan NotificationView
        let adhanView = NotificationView()
        
        
        // Create and add Iqama NotificationView
        let iqamaView = NotificationView()
        
        if is_jumaa {
            adhanView.titleLabel.text = "Khutba Notifications"
            adhanView.descriptionLabel.text = "Set Notifcations for 1 Hour before Jumaa Khutba"
            adhanView.switchControl.isOn = adhan_bool
            
            iqamaView.titleLabel.text = "Salah Notifications"
            iqamaView.descriptionLabel.text = "Set Notifcations for 1 Hour before Jumaa Salah"
            iqamaView.switchControl.isOn = iqama_bool
        }
        else {
            adhanView.titleLabel.text = "Adhan Notifications"
            adhanView.descriptionLabel.text = "Set Notifcations for \(prayerName) adhan"
            adhanView.switchControl.isOn = adhan_bool
            
            iqamaView.titleLabel.text = "Iqama Notifications"
            iqamaView.descriptionLabel.text = "Set Notifcations for 20 Minutes before \(prayerName) iqama"
            iqamaView.switchControl.isOn = iqama_bool
        }
        
        adhanView.switchValueChanged = { [weak self] isOn in self?.handleSwitchToggle(isAdhanSwitch: true, newValue: isOn) }
        iqamaView.switchValueChanged = { [weak self] isOn in self?.handleSwitchToggle(isAdhanSwitch: false, newValue: isOn) }
        
        
        // Add views to the hierarchy
        view.addSubview(adhanView)
        view.addSubview(iqamaView)
        
        adhanView.translatesAutoresizingMaskIntoConstraints = false
        iqamaView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: self.bottomOfImage + 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            adhanView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            adhanView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adhanView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            adhanView.heightAnchor.constraint(equalToConstant: 120),
            
            iqamaView.topAnchor.constraint(equalTo: adhanView.bottomAnchor, constant: 10),
            iqamaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iqamaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iqamaView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func handleSwitchToggle(isAdhanSwitch: Bool, newValue: Bool) {
        let fieldName = isAdhanSwitch ? adhan_field_name : iqama_field_name
        
        if newValue {
            FirebaseManager.subscribeToTopic(topic: fieldName)
        } else {
            FirebaseManager.unsubscribeToTopic(topic: fieldName)
        }
        
        delegate?.updateAlarmStatus(for: prayerName, isAdhanEnabled: isAdhanSwitch ? newValue : adhan_bool, isIqamaEnabled: isAdhanSwitch ? iqama_bool : newValue)
        DataManager.setSingleUserPreference(fieldName, newValue)
    }
}
