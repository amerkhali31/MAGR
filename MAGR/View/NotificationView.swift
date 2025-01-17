//
//  NotificationView.swift
//  MAGR
//
//  Created by Amer Khalil on 1/13/25.
//

import UIKit

class NotificationView: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let switchControl = UISwitch()
    
    var switchValueChanged: ((Bool) -> Void)?
    
    init(title: String = "", description: String = "", isSwitchOn: Bool = false) {
        super.init(frame: .zero)
        setupView(title: title, description: description, isSwitchOn: isSwitchOn)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(title: String, description: String, isSwitchOn: Bool) {
        // Configure view appearance
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
        // Configure titleLabel
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        // Configure descriptionLabel
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        
        // Configure switchControl
        switchControl.isOn = isSwitchOn
        switchControl.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(switchControl)
        
        // Set up constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            switchControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            switchControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            switchControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func switchToggled() {
        switchValueChanged?(switchControl.isOn)
    }
}
