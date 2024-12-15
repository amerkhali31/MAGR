//
//  PrayerView.swift
//  MAGR
//
//  Created by Amer Khalil on 12/13/24.
//

import UIKit

class PrayerView: UIView {
    
    var onTouch: (() -> Void)?
    
    // MARK: - UI Elements
    private let iconView = UIImageView()  // Left icon
    private let prayerLabel = UILabel()  // Left label
    private let adhanLabel = UILabel()   // Center label
    private let iqamaLabel = UILabel()   // Right label
    private let alarmIconView = UIImageView() // Alarm symbol on the right of iqamaLabel
    var status = false
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupIcon()
        setupLabels()
        setupAlarmIcon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupIcon()
        setupLabels()
        setupAlarmIcon()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func handleTap() {onTouch?()}
    
    private func setupIcon() {
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .white  // Default color for SF Symbols
        self.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupLabels() {
        // Configure labels with shared styles
        let labels = [prayerLabel, adhanLabel, iqamaLabel]
        for label in labels {
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
        }
        
        // Layout for prayerLabel
        NSLayoutConstraint.activate([
            prayerLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            prayerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Layout for adhanLabel
        NSLayoutConstraint.activate([
            adhanLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            adhanLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Layout for iqamaLabel
        NSLayoutConstraint.activate([
            iqamaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40), // Leave space for the alarm icon
            iqamaLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupAlarmIcon() {
        alarmIconView.contentMode = .scaleAspectFit
        alarmIconView.translatesAutoresizingMaskIntoConstraints = false
        alarmIconView.tintColor = .gray  // Default color for alarm symbol
        alarmIconView.image = UIImage(systemName: "alarm") // SF Symbol for alarm
        self.addSubview(alarmIconView)
        
        NSLayoutConstraint.activate([
            alarmIconView.leadingAnchor.constraint(equalTo: iqamaLabel.trailingAnchor, constant: 10),
            alarmIconView.centerYAnchor.constraint(equalTo: iqamaLabel.centerYAnchor),
            alarmIconView.widthAnchor.constraint(equalToConstant: 20),
            alarmIconView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Public Methods
    func configure(icon: UIImage?, prayer: String, adhan: String, iqama: String) {
        iconView.image = icon
        prayerLabel.text = prayer
        adhanLabel.text = adhan
        iqamaLabel.text = iqama
    }
    
    func setBorderColor(_ visible: Bool) {
        self.layer.borderColor = visible ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
    
    func attachTo(parentView: UIView, topAnchor: NSLayoutYAxisAnchor, topInset: CGFloat = 10, height: CGFloat = 60, xInset: CGFloat = 10) {
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            self.heightAnchor.constraint(equalToConstant: height),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: xInset),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -xInset)
            
        ])
    }
    
    func alarmToggle(_ prayer: DailyPrayer) {
        status = !status
        
        DataManager.NotificationEntities[prayer.name]?.status = status
        NotificationManager.deleteNotification(prayer.name)
        
        if status {
            alarmIconView.tintColor = .white
            let date = TimeManager.createDateFromTime(prayer.adhan)
            NotificationManager.scheduleNotification(at: date, prayer.name, prayer.name)
        }
        else {
            alarmIconView.tintColor = .gray
        }
        
        DataManager.saveDatabase()

    }
    
    func setAlarmStatus(to entityStatus: Bool) {
        status = entityStatus
        if status {alarmIconView.tintColor = .white}
    }
}
