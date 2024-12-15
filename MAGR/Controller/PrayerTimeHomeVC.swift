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
    
    let todayLabel = PrayerChoiceLabel(text: "Today", status: false)
    let monthlyLabel = PrayerChoiceLabel(text: "Monthly", status: true)
    
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
    let monthlyTable = UITableView()
    let fajrLabel = UILabel()
    let dhuhrLabel = UILabel()
    let asrLabel = UILabel()
    let maghribLabel = UILabel()
    let ishaLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayLabel.attachTo(parentView: view, topAnchor: view.topAnchor, topInset: bottomOfImage + 10, lead: view.leadingAnchor)
        todayLabel.onTap = {self.todayTapped()}
        monthlyLabel.attachTo(parentView: self.view, topAnchor: todayLabel.topAnchor, lead: todayLabel.trailingAnchor)
        monthlyLabel.onTap = {self.monthTapped()}
        
        todayView.isHidden = true
        configureTodayView()
        configureMonthView()
    }

}

// MARK: Major Labels
extension PrayerTimeHomeVC {
    
    func todayTapped() {
        
        todayLabel.wasTapped()
        monthlyLabel.wasntTapped()
        
        monthView.isHidden = true
        todayView.isHidden = false
    }
    
    func monthTapped() {
        
        monthlyLabel.wasTapped()
        todayLabel.wasntTapped()
        
        todayView.isHidden = true
        monthView.isHidden = false
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
            todayView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
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
        fajrView.configure(icon: UIImage(systemName: "moon"),
                           prayer: "Fajr",
                           adhan: DataManager.getFajrToday().adhan,
                           iqama: DataManager.getFajrToday().iqama)
        fajrView.attachTo(parentView: todayView, topAnchor: adhanLabel.bottomAnchor, topInset: 10)
        fajrView.layer.borderColor = UIColor.white.cgColor
        
        dhuhrView.configure(icon: UIImage(systemName: "sun.max"),
                            prayer: "Dhuhr",
                            adhan: DataManager.getDhuhrToday().adhan,
                            iqama: DataManager.getDhuhrToday().iqama)
        dhuhrView.attachTo(parentView: todayView, topAnchor: fajrView.bottomAnchor)
        
        asrView.configure(icon: UIImage(systemName: "sun.min"),
                          prayer: "Asr",
                          adhan: DataManager.getAsrToday().adhan,
                          iqama: DataManager.getAsrToday().iqama)
        asrView.attachTo(parentView: todayView, topAnchor: dhuhrView.bottomAnchor)

        maghribView.configure(icon: UIImage(systemName: "sun.horizon"),
                              prayer: "Maghrib",
                              adhan: DataManager.getMaghribToday().adhan,
                              iqama: DataManager.getMaghribToday().iqama)
        maghribView.attachTo(parentView: todayView, topAnchor: asrView.bottomAnchor)
        
        ishaView.configure(icon: UIImage(systemName: "moon"),
                           prayer: "Isha",
                           adhan: DataManager.getIshaToday().adhan,
                           iqama: DataManager.getIshaToday().iqama)
        ishaView.attachTo(parentView: todayView, topAnchor: maghribView.bottomAnchor)

        khutbaView.configure(icon: UIImage(systemName: "music.mic"),
                             prayer: "Khutba",
                             adhan: DataManager.getKhutba().adhan,
                             iqama:DataManager.getKhutba().iqama)
        khutbaView.attachTo(parentView: todayView, topAnchor: ishaView.bottomAnchor, topInset: 50)
        
        jumaaView.configure(icon: UIImage(systemName: "sun.max"),
                            prayer: "Salah",
                            adhan: DataManager.getJumaa().adhan,
                            iqama: DataManager.getJumaa().iqama)
        jumaaView.attachTo(parentView: todayView, topAnchor: khutbaView.bottomAnchor)
    }
}

// MARK: - Month View Configuration
extension PrayerTimeHomeVC {
    
    func configureMonthView() {
        
        //monthView.isHidden = true
        
        // Add `todayView` to the parent view
        monthView.backgroundColor = .blue
        monthView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthView)
        
        // Set constraints for `todayView`
        NSLayoutConstraint.activate([
            monthView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            monthView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            monthView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
            monthView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        //Add Content to the view
        setupMonthlyLabels()
        setupMonthlyTable()
    }
    
    func setupMonthlyTable() {
        
        
        monthlyTable.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(monthlyTable)
        
        NSLayoutConstraint.activate([
        ])
        
    }
    
    private func setupMonthlyLabels() {
        
        let labels = [TimeManager.getMonthName(DataManager.getTodaysDate()), "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
        var labelViews: [UILabel] = []
        
        for (index, labelText) in labels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1
            monthView.addSubview(label)
            labelViews.append(label)
            label.adjustsFontSizeToFitWidth = true
            
            // Set constraints
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: monthView.topAnchor, constant: 5),
                label.widthAnchor.constraint(equalTo: monthView.widthAnchor, multiplier: 1.0 / 6.0),
                label.leadingAnchor.constraint(equalTo: monthView.leadingAnchor, constant: CGFloat(index) * view.frame.width / 6.0)
            ])
        }
    }
    
}
