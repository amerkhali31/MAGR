//
//  PrayerTimeHomeVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class PrayerTimeHomeVC: BaseBackgroundViewController {
    
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
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                rightSwipe.direction = .right
                view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                leftSwipe.direction = .left
                view.addGestureRecognizer(leftSwipe)
                
        todayLabel.attachTo(parentView: view, topAnchor: view.topAnchor, topInset: bottomOfImage + 10, lead: view.leadingAnchor)
        todayLabel.onTap = {self.todayTapped()}
        
        monthlyLabel.attachTo(parentView: self.view, topAnchor: todayLabel.topAnchor, lead: todayLabel.trailingAnchor)
        monthlyLabel.onTap = {self.monthTapped()}

        configureTodayView()
        configureMonthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

}

// MARK: Major Labels
extension PrayerTimeHomeVC {
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            todayTapped()
        case .left:
            monthTapped()
        default:
            break
        }
    }
    
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
        initializeAlarmStatuses()
    }
    
    func setupTopLabels() {
        
        configureLabel(labelToConfigure: dateLabel, text: TimeManager.formatDateToReadable(DataManager.todaysDate, false) ?? "No Date", 100)
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
        fajrView.configure(icon: UIImage(systemName: "moon"), prayer: DataManager.fajrToday)
        fajrView.attachTo(parentView: todayView, topAnchor: adhanLabel.bottomAnchor, topInset: 10)
        fajrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.fajrToday)}
        
        dhuhrView.configure(icon: UIImage(systemName: "sun.max"), prayer: DataManager.dhuhrToday)
        dhuhrView.attachTo(parentView: todayView, topAnchor: fajrView.bottomAnchor)
        dhuhrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.dhuhrToday)}
        
        asrView.configure(icon: UIImage(systemName: "sun.min"), prayer: DataManager.asrToday)
        asrView.attachTo(parentView: todayView, topAnchor: dhuhrView.bottomAnchor)
        asrView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.asrToday)}
        
        maghribView.configure(icon: UIImage(systemName: "sun.horizon"), prayer: DataManager.maghribToday)
        maghribView.attachTo(parentView: todayView, topAnchor: asrView.bottomAnchor)
        maghribView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.maghribToday)}
        
        ishaView.configure(icon: UIImage(systemName: "moon"), prayer: DataManager.ishaToday)
        ishaView.attachTo(parentView: todayView, topAnchor: maghribView.bottomAnchor)
        ishaView.onTouch = {self.prayerTouch(dailyPrayer: DataManager.ishaToday)}
        
        khutbaView.configure(icon: UIImage(systemName: "music.mic"), prayer: DataManager.khutbaToday, show: false, jumaa: true)
        khutbaView.attachTo(parentView: todayView, topAnchor: ishaView.bottomAnchor, topInset: 50)
        
        jumaaView.configure(icon: UIImage(systemName: "sun.max"), prayer: DataManager.jumaaToday, show: false, jumaa: true)
        jumaaView.attachTo(parentView: todayView, topAnchor: khutbaView.bottomAnchor)
        
        highlightCurrentPrayer()
    }
    
    func highlightCurrentPrayer() {
        switch PrayerManager.findCurrentPrayer().name {
        case K.DailyPrayerDisplayNames.fajr: fajrView.layer.borderColor = UIColor.white.cgColor
        case K.DailyPrayerDisplayNames.dhuhr: dhuhrView.layer.borderColor = UIColor.white.cgColor
        case K.DailyPrayerDisplayNames.asr: asrView.layer.borderColor = UIColor.white.cgColor
        case K.DailyPrayerDisplayNames.maghrib: maghribView.layer.borderColor = UIColor.white.cgColor
        case K.DailyPrayerDisplayNames.isha: ishaView.layer.borderColor = UIColor.white.cgColor
        default: fajrView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // need to add a function to initialize status of alarm icons
}

// MARK: Functionality for when prayer times are touched
extension PrayerTimeHomeVC {

    func prayerTouch(dailyPrayer: DailyPrayer) {

        let prayerVC = PrayerNoticeViewController()
        var inputs: [String] = []
        
        switch dailyPrayer.name {
            case K.DailyPrayerDisplayNames.fajr: inputs = [dailyPrayer.name,K.userDefaults.fajr_adhan_notification, K.userDefaults.fajr_iqama_notification]
            case K.DailyPrayerDisplayNames.dhuhr: inputs = [dailyPrayer.name,K.userDefaults.dhuhr_adhan_notification, K.userDefaults.dhuhr_iqama_notification]
            case K.DailyPrayerDisplayNames.asr: inputs = [dailyPrayer.name,K.userDefaults.asr_adhan_notification, K.userDefaults.asr_iqama_notification]
            case K.DailyPrayerDisplayNames.maghrib: inputs = [dailyPrayer.name,K.userDefaults.maghrib_adhan_notification, K.userDefaults.maghrib_iqama_notification]
            case K.DailyPrayerDisplayNames.isha: inputs = [dailyPrayer.name,K.userDefaults.isha_adhan_notification, K.userDefaults.isha_iqama_notification]
            default: print()
        }
        
        prayerVC.inputs = inputs
        prayerVC.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(prayerVC, animated: true)
        }
    }
    
    func initializeAlarmStatuses() {
        // Initialize Fajr
        if DataManager.prayer_notification_preferences[K.userDefaults.fajr_adhan_notification] ?? false ||
            DataManager.prayer_notification_preferences[K.userDefaults.fajr_iqama_notification] ?? false {
            fajrView.setAlarmStatus(to: true)
        } else {fajrView.setAlarmStatus(to: false)}
        
        
        if DataManager.prayer_notification_preferences[K.userDefaults.dhuhr_adhan_notification] ?? false ||
            DataManager.prayer_notification_preferences[K.userDefaults.dhuhr_iqama_notification] ?? false {
            dhuhrView.setAlarmStatus(to: true)
        } else {dhuhrView.setAlarmStatus(to: false)}
        
        if DataManager.prayer_notification_preferences[K.userDefaults.asr_adhan_notification] ?? false ||
            DataManager.prayer_notification_preferences[K.userDefaults.asr_iqama_notification] ?? false {
            asrView.setAlarmStatus(to: true)
        } else {asrView.setAlarmStatus(to: false)}
        
        if DataManager.prayer_notification_preferences[K.userDefaults.maghrib_adhan_notification] ?? false ||
            DataManager.prayer_notification_preferences[K.userDefaults.maghrib_iqama_notification] ?? false {
            maghribView.setAlarmStatus(to: true)
        } else {maghribView.setAlarmStatus(to: false)}
        
        if DataManager.prayer_notification_preferences[K.userDefaults.isha_adhan_notification] ?? false ||
            DataManager.prayer_notification_preferences[K.userDefaults.isha_iqama_notification] ?? false {
            ishaView.setAlarmStatus(to: true)
        } else {ishaView.setAlarmStatus(to: false)}
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
        
        let labels = [TimeManager.getMonthName(DataManager.todaysDate), "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
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

        if let range = Calendar.current.range(of: .day, in: .month, for: Date()) {
            return DataManager.MonthlyPrayerEntities[0..<range.count].count
        }
        return DataManager.MonthlyPrayerEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyPrayerCell", for: indexPath) as? MonthlyPrayerCell else {
            return UITableViewCell() }
        
        let data = DataManager.MonthlyPrayerEntities[indexPath.row]
        //cell.backgroundColor = .clear
        cell.configure(with: data)
        cell.isUserInteractionEnabled = false
        return cell
    }
}

extension PrayerTimeHomeVC: PrayerNoticeViewControllerDelegate {
    func updateAlarmStatus(for prayerName: String, isAdhanEnabled: Bool, isIqamaEnabled: Bool) {
        // Determine the new alarm status based on the rules
        let isAlarmOn = isAdhanEnabled || isIqamaEnabled

        // Update the corresponding PrayerView's alarm icon status
        switch prayerName {
        case K.DailyPrayerDisplayNames.fajr:
            fajrView.setAlarmStatus(to: isAlarmOn)
        case K.DailyPrayerDisplayNames.dhuhr:
            dhuhrView.setAlarmStatus(to: isAlarmOn)
        case K.DailyPrayerDisplayNames.asr:
            asrView.setAlarmStatus(to: isAlarmOn)
        case K.DailyPrayerDisplayNames.maghrib:
            maghribView.setAlarmStatus(to: isAlarmOn)
        case K.DailyPrayerDisplayNames.isha:
            ishaView.setAlarmStatus(to: isAlarmOn)
        default:
            break
        }
    }
}
