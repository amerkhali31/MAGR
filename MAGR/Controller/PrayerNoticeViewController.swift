//
//  PrayerNoticeViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/24/24.
//

import UIKit

class PrayerNoticeViewController: BaseBackgroundViewController {
    
    var dailyPrayer: DailyPrayer? // Property to store the passed object
    private let dragHandle = UIView()
    
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
        
        view.backgroundColor = .green
        setupUI()
        
        // Set the title dynamically using the passed `DailyPrayer` object
        if let dailyPrayer = dailyPrayer {
            titleLabel.text = "\(dailyPrayer.name) Notification Settings"
        }
    }
    
    private func setupUI() {
        setupDragHandle()
        
        // Add the title label
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and add Adhan and Iqama views
        let adhanView = createNotificationView(
            title: "Adhan Notifications",
            description: "Enable or disable notifications for \(dailyPrayer?.name ?? "this prayer") adhan."
        )
        let iqamaView = createNotificationView(
            title: "Iqama Notifications",
            description: "Enable or disable notifications for \(dailyPrayer?.name ?? "this prayer") iqama."
        )
        
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
    
    private func createNotificationView(title: String, description: String) -> UIView {
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
        
        let switchControl = UISwitch()
        
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
    
    private func setupDragHandle() {
        // Configure the drag handle view
        dragHandle.backgroundColor = UIColor.lightGray
        dragHandle.layer.cornerRadius = 3
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dragHandle)
        
        // Set constraints for the drag handle
        NSLayoutConstraint.activate([
            dragHandle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dragHandle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 50),
            dragHandle.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
