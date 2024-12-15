//
//  MonthlyPrayerCell.swift
//  MAGR
//
//  Created by Amer Khalil on 12/14/24.
//

import UIKit

class MonthlyPrayerCell: UITableViewCell {
    // MARK: - UI Elements
    private let dayLabel = UILabel()
    private let fajrLabel = UILabel()
    private let dhuhrLabel = UILabel()
    private let asrLabel = UILabel()
    private let maghribLabel = UILabel()
    private let ishaLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupLabels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupLabels()
        contentView.backgroundColor = .clear
    }

    // MARK: - Setup Methods
    private func setupCell() {
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupLabels() {
        // Common label settings
        let labels = [dayLabel, fajrLabel, dhuhrLabel, asrLabel, maghribLabel, ishaLabel]
        for label in labels {
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .white
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            stackView.addArrangedSubview(label)
        }
    }

    // MARK: - Configuration Method
    func configure(with data: MonthlyPrayerEntity) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: data.date!) ?? Date()

        let calendar = Calendar.current
        let todayDate = calendar.component(.day, from: date)

        dayLabel.text = "\(todayDate)"
        fajrLabel.text = TimeManager.convert24HrTimeTo12HrTime(data.fajr!)
        dhuhrLabel.text = TimeManager.convert24HrTimeTo12HrTime(data.dhuhr!)
        asrLabel.text = TimeManager.convert24HrTimeTo12HrTime(data.asr!)
        maghribLabel.text = TimeManager.convert24HrTimeTo12HrTime(data.maghrib!)
        ishaLabel.text = TimeManager.convert24HrTimeTo12HrTime(data.isha!)
        
    }
}
