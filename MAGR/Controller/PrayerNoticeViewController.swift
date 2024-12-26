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
    
    private let adhan_switch = UISwitch()
    private let iqama_switch = UISwitch()
    
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
        
        // Create and add Adhan and Iqama views
        let adhanView = createNotificationView(
            title: "Adhan Notifications",
            description: "Enable or disable notifications for \(prayerName) adhan.",
            Switch: adhan_switch
        )
        adhan_switch.isOn = adhan_bool
        adhan_switch.addTarget(self, action: #selector(handleSwitchToggle(_:)), for: .valueChanged)
        
        let iqamaView = createNotificationView(
            title: "Iqama Notifications",
            description: "Enable or disable notifications for \(prayerName) iqama.",
            Switch: iqama_switch
        )
        iqama_switch.isOn = iqama_bool
        iqama_switch.addTarget(self, action: #selector(handleSwitchToggle(_:)), for: .valueChanged)

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
    
    @objc private func handleSwitchToggle(_ sender: UISwitch) {
        
        // Boolean representing whether sender is adhan switch or not
        let isAdhanSwitch = sender == adhan_switch
        
        // set field name to adhan_field_name if sender was adhan switch or iqama_field_name if it wasnt
        let fieldName = isAdhanSwitch ? adhan_field_name : iqama_field_name
        
        // Get the value of the switch to give to firebase
        let newValue = sender.isOn
        
        // Update the DataManager's local preferences
        DataManager.setSingleUserPreference(fieldName, newValue)
        FirebaseManager.updateUserPreferences(update: fieldName, to: newValue)
        delegate?.updateAlarmStatus(for: prayerName, isAdhanEnabled: adhan_switch.isOn, isIqamaEnabled: iqama_switch.isOn)

    }

    
    private func createNotificationView(title: String, description: String, Switch: UISwitch) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        
        let switchControl = Switch
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(switchControl)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            switchControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            switchControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        return containerView
    }
    
}
