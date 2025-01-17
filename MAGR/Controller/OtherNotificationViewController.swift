//
//  PrayerNoticeViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/24/24.
//

import UIKit
import Firebase

class OtherNotificationViewController: BaseBackgroundViewController {
    
    var notice_name: String = ""
    var notice_bool: Bool = false
    var field_name: String = ""
    
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
            notice_name = safeInputs[0]
            field_name = safeInputs[1]
            
            notice_bool = DataManager.prayer_notification_preferences[field_name] ?? false
        }
    }
    
    private func setupUI() {
        
        // Add the title label
        titleLabel.text = "Notification Settings"
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and add Adhan NotificationView
        let notice_view = NotificationView()

        notice_view.titleLabel.text = "\(notice_name) Notifications"
        notice_view.descriptionLabel.text = "Set Notifcations for \(notice_name)"
        notice_view.switchControl.isOn = notice_bool

        notice_view.switchValueChanged = { [weak self] isOn in self?.handleSwitchToggle(isAdhanSwitch: true, newValue: isOn) }
        
        
        // Add views to the hierarchy
        view.addSubview(notice_view)
        
        notice_view.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: self.bottomOfImage + 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            notice_view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            notice_view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notice_view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notice_view.heightAnchor.constraint(equalToConstant: 120),

        ])
    }
    
    private func handleSwitchToggle(isAdhanSwitch: Bool, newValue: Bool) {
        let fieldName = field_name
        
        if newValue {
            FirebaseManager.subscribeToTopic(topic: fieldName)
        } else {
            FirebaseManager.unsubscribeToTopic(topic: fieldName)
        }
        
        DataManager.setSingleUserPreference(fieldName, newValue)
    }
}
