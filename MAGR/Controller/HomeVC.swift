//
//  HomeVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class HomeVC: BaseBackgroundViewController {
    
    // Views
    let scrollView = UIScrollView()
    let contentView = UIView()
    let pageControl = UIPageControl()
    
    // Content
    let standardSpace: CGFloat = 10
    let standardXinset: CGFloat = 10
    
    let dateLabel = UILabel()
    let arabDateLabel = UILabel()
    
    let prayerBox = PrayerBox()
    var timeUntilNextPrayer: Int = 0
    var nextPrayer = ""
    
    let announcementBox = HomeBox()
    let verseBox = HomeBox()
    let contactBox = HomeBox()
    let donationBox = HomeBox()
    let qiblaBox = HomeBox()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupContentView()
        setupContent()
        
    }
    


}

// MARK: Setup the scroll view
extension HomeVC {
    
    func setupScrollView() {
        
        // add the scrollview to superview
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the top of the scrollview to be 10 points below the bottom of the logo image whose top is at the top of the nav bar
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.bottomOfImage + 10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    func setupContentView() {
        
        // Set up the content view inside the scroll view
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constrain it
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            // Width constraint to match the scroll view's width
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
    
}

// MARK: Content
extension HomeVC {
    
    func setupLabels() {
        
        dateLabel.text = TimeManager.formatDateToReadable(DataManager.getTodaysDate(), true)
        arabDateLabel.text = TimeManager.convertToIslamicDate(from: Date())
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        arabDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.textColor = .white
        arabDateLabel.textColor = .white
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(arabDateLabel)
        
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardXinset),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardXinset),
            dateLabel.heightAnchor.constraint(equalToConstant: 21),
            arabDateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0),
            arabDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardXinset),
            arabDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardXinset),
            arabDateLabel.heightAnchor.constraint(equalToConstant: 21),
        ])
        
    }
    
    func setupContent() {
        
        setupLabels()
        
        prayerBox.configure(icon: UIImage(systemName: "moon"), topText: "Next Prayer: \(DataManager.getNextPrayer().name)", countdownText: "")
        prayerBox.attachTo(parentView: contentView, topAnchor: arabDateLabel.bottomAnchor, topInset: standardSpace, xInset: standardXinset, height: 150)
        prayerBox.topLabel.adjustsFontSizeToFitWidth = true
        updateTimer() // call once to initialize it and not have to wait 1 second for it to start displaying
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        prayerBox.onTouch = {self.prayerTouched()}
        
        announcementBox.configure(icon: UIImage(systemName: "bell"), topText: "Announcements", bottomText: "Stay up to date with MAGR news")
        announcementBox.attachTo(parentView: contentView, topAnchor: prayerBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        announcementBox.onTouch = {self.announceTouched()}
        
        verseBox.configure(icon: UIImage(systemName: "book"), topText: "Verse of the Day", bottomText: "Reflect on the wisdom of the Quran")
        verseBox.attachTo(parentView: contentView, topAnchor: announcementBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        verseBox.onTouch = {self.verseTouched()}
        
        contactBox.configure(icon: UIImage(systemName: "phone"), topText: "Contact Us", bottomText: "Find all of our contact information")
        contactBox.attachTo(parentView: contentView, topAnchor: verseBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        contactBox.onTouch = {self.contactTouched()}
        
        donationBox.configure(icon: UIImage(systemName: "dollarsign.circle"), topText: "Donate", bottomText: "Increase in charity")
        donationBox.attachTo(parentView: contentView, topAnchor: contactBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        donationBox.onTouch = {self.donateTouched()}
        
        qiblaBox.configure(icon: UIImage(systemName: "safari"), topText: "Qibla Finder", bottomText: "Get the correct prayer direction wherever you are")
        qiblaBox.attachTo(parentView: contentView, topAnchor: donationBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        qiblaBox.onTouch = {self.donateTouched()}
        qiblaBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    /// Will be used to update the label for the prayer time
    @objc func updateTimer() {
        var timeUntilNextPrayer = PrayerManager.getTimeUntilNextPrayer()
        let time = TimeManager.convertSecondsToTime(timeUntilNextPrayer)
        
        if timeUntilNextPrayer > 0 {
            timeUntilNextPrayer -= 1
            
            let formattedHours = String(format: "%02d", time.hours)
            let formattedMinutes = String(format: "%02d", time.minutes)
            let formattedSeconds = String(format: "%02d", time.seconds)
            let formattedTime = "\(formattedHours):\(formattedMinutes):\(formattedSeconds)"
            
            prayerBox.countdownLabel.text = "\(formattedTime)"
            
        }
    }
    
}

// MARK: Handling Touch Events
extension HomeVC {
    
    func announceTouched() {
        self.performSegue(withIdentifier: K.segues.announceSegue, sender: self)
    }
    
    func prayerTouched() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    func verseTouched() {
        
    }
    
    func contactTouched() {
        
    }
    
    func donateTouched() {
        
    }
    
}
