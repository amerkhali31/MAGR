//
//  PrayerTimeHomeVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class PrayerTimeHomeVC: BaseBackgroundViewController {
    
    // Complete View
    let todayView = UIView()
    let monthView = UIView()
    
    let todayLabel = PrayerChoiceLabel(text: "Today", status: true)
    let monthlyLabel = PrayerChoiceLabel(text: "Monthly", status: false)
    
    // Today View
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
    
    var currentPrayer = "Fajr"
    
    // Month View
    let monthlyDateLabel = UILabel()
    let monthlyTable = UITableView()
    let fajrLabel = UILabel()
    let dhuhrLabel = UILabel()
    let asrLabel = UILabel()
    let maghribLabel = UILabel()
    let ishaLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currentPrayer = PrayerManager.findCurrentPrayer()
        
        todayLabel.attachTo(parentView: view, topAnchor: view.topAnchor, topInset: bottomOfImage + 10, lead: view.leadingAnchor)
        todayLabel.onTap = {self.todayTapped()}
        
        monthlyLabel.attachTo(parentView: self.view, topAnchor: todayLabel.topAnchor, lead: todayLabel.trailingAnchor)
        monthlyLabel.onTap = {self.monthTapped()}

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
        
        configureLabel(labelToConfigure: dateLabel, text: TimeManager.formatDateToReadable(DataManager.getTodaysDate(), false) ?? "No Date", 100)
        dateLabel.leadingAnchor.constraint(equalTo: todayView.leadingAnchor, constant: 0).isActive = true
        dateLabel.adjustsFontSizeToFitWidth = true

        configureLabel(labelToConfigure: adhanLabel, text: "Adhan")
        adhanLabel.centerXAnchor.constraint(equalTo: todayView.centerXAnchor).isActive = true

        configureLabel(labelToConfigure: iqamaLabel, text: "Iqama")
        iqamaLabel.trailingAnchor.constraint(equalTo: todayView.trailingAnchor, constant: -60).isActive = true
    }
    
    func configureLabel(labelToConfigure label: UILabel, text: String, _ width: CGFloat = 60) {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        todayView.addSubview(label)
        
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: width),
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
                             prayer: "Jumaa",
                             adhan: "Khutba",
                             iqama:DataManager.getKhutba().iqama)
        khutbaView.attachTo(parentView: todayView, topAnchor: ishaView.bottomAnchor, topInset: 50)
        
        jumaaView.configure(icon: UIImage(systemName: "sun.max"),
                            prayer: "Jumaa",
                            adhan: "Salah",
                            iqama: DataManager.getJumaa().iqama)
        jumaaView.attachTo(parentView: todayView, topAnchor: khutbaView.bottomAnchor)
        
        highlightCurrentPrayer()
    }
    
    func highlightCurrentPrayer() {
        switch currentPrayer {
        case K.FireStore.dailyPrayers.names.fajr: fajrView.layer.borderColor = UIColor.white.cgColor
        case K.FireStore.dailyPrayers.names.dhuhr: dhuhrView.layer.borderColor = UIColor.white.cgColor
        case K.FireStore.dailyPrayers.names.asr: asrView.layer.borderColor = UIColor.white.cgColor
        case K.FireStore.dailyPrayers.names.maghrib: maghribView.layer.borderColor = UIColor.white.cgColor
        case K.FireStore.dailyPrayers.names.isha: ishaView.layer.borderColor = UIColor.white.cgColor
        default: fajrView.layer.borderColor = UIColor.white.cgColor
        }
    }
}

// MARK: - Month View Configuration
extension PrayerTimeHomeVC {
    
    func configureMonthView() {
        
        monthView.isHidden = true
        
        monthView.backgroundColor = .clear
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
        
        monthlyTable.backgroundColor = .clear
        monthlyTable.translatesAutoresizingMaskIntoConstraints = false
        monthView.addSubview(monthlyTable)
        
        monthlyTable.delegate = self
        monthlyTable.dataSource = self
        
        monthlyTable.register(MonthlyPrayerCell.self, forCellReuseIdentifier: "MonthlyPrayerCell")
        monthlyTable.rowHeight = 50
        
        NSLayoutConstraint.activate([
            monthlyTable.topAnchor.constraint(equalTo: fajrLabel.bottomAnchor, constant: 5),
            monthlyTable.leadingAnchor.constraint(equalTo: monthView.leadingAnchor),
            monthlyTable.trailingAnchor.constraint(equalTo: monthView.trailingAnchor),
            monthlyTable.bottomAnchor.constraint(equalTo: monthView.bottomAnchor)
        ])
    }
    
    private func setupMonthlyLabels() {
        
        let labels = [TimeManager.getMonthName(DataManager.getTodaysDate()), "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
        let labelViews: [UILabel] = [monthlyDateLabel, fajrLabel, dhuhrLabel, asrLabel, maghribLabel, ishaLabel]
        
        for (index, labelText) in labels.enumerated() {
            let label = labelViews[index]
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false

            monthView.addSubview(label)
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

extension PrayerTimeHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Add green half-opaque background to every other row
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.MAGR_4.withAlphaComponent(0.5) // Green with 50% opacity
            } else {
                cell.backgroundColor = .clear // Default background for odd rows
            }
        }
    
}

extension PrayerTimeHomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.getMonthlyPrayerEntities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyPrayerCell", for: indexPath) as? MonthlyPrayerCell else {
            return UITableViewCell() }
        
        let data = DataManager.getMonthlyPrayerEntities()[indexPath.row]
        //cell.backgroundColor = .clear
        cell.configure(with: data)
        return cell
    }
}
