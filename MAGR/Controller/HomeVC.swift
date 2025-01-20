//
//  HomeVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class HomeVC: BaseBackgroundViewController {
    
    var onYesTapped: (() -> Void)?
    
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
    var nextPrayer = DataManager.nextPrayer
    
    let announcementBox = HomeBox()
    let verseBox = HomeBox()
    let contactBox = HomeBox()
    let donationBox = HomeBox()
    let qiblaBox = HomeBox()
    let feedbackBox = HomeBox()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupContentView()
        setupContent()
        shouldPresent()
        
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
        
        dateLabel.text = TimeManager.formatDateToReadable(DataManager.todaysDate, true)
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
        
        prayerBox.configure(prayer: nextPrayer)
        prayerBox.attachTo(parentView: contentView, topAnchor: arabDateLabel.bottomAnchor, topInset: standardSpace, xInset: standardXinset, height: 150)
        prayerBox.topLabel.adjustsFontSizeToFitWidth = true
        updateTimer() // call once to initialize it and not have to wait 1 second for it to start displaying
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        prayerBox.onTouch = {self.prayerTouched()}
        
        announcementBox.configure(icon: UIImage(systemName: "bell"), topText: "Announcements", bottomText: "Stay up to date with MAGR news")
        announcementBox.attachTo(parentView: contentView, topAnchor: prayerBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        announcementBox.onTouch = {self.announceTouched()}
        
        verseBox.configure(icon: UIImage(systemName: "book"), topText: "Hadith of the Day", bottomText: "Reflect on the wisdom of Hadith")
        verseBox.attachTo(parentView: contentView, topAnchor: announcementBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        verseBox.onTouch = {
            Task {
                await self.verseTouched()
            }
        }
        contactBox.configure(icon: UIImage(systemName: "phone"), topText: "Contact Us", bottomText: "Find all of our contact information")
        contactBox.attachTo(parentView: contentView, topAnchor: verseBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        contactBox.onTouch = {self.contactTouched()}
        
        donationBox.configure(icon: UIImage(systemName: "dollarsign.circle"), topText: "Donate", bottomText: "Increase in charity")
        donationBox.attachTo(parentView: contentView, topAnchor: contactBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        donationBox.onTouch = {self.donateTouched()}
        
        feedbackBox.configure(icon: UIImage(systemName: "text.bubble"), topText: "Feedback", bottomText: "Tell us how to improve")
        feedbackBox.attachTo(parentView: contentView, topAnchor: donationBox.bottomAnchor)
        feedbackBox.onTouch = {self.feedbackTouched()}
        feedbackBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
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
    
    func verseTouched() async {
        
        let overlayView = UIView(frame: view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.isUserInteractionEnabled = true
        view.addSubview(overlayView)
        // Create and configure the loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.color = .white
        loadingIndicator.alpha = 1.0
        loadingIndicator.startAnimating()
        
        // Add the loading indicator to the view
        DispatchQueue.main.async { [weak self] in
            
            self?.view.addSubview(loadingIndicator)
        }
        
        // Fetch hadiths data
        let apiResponse = await HadithApiManager.fetchHadiths()
        
        // Remove the loading indicator once the data is fetched
        DispatchQueue.main.async { [] in
            loadingIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        }

        // Prepare and present the Hadith view controller
        let hadithVC = HadithViewController()
        hadithVC.apiResponse = apiResponse
        
        DispatchQueue.main.async { [weak self] in
            self?.present(hadithVC, animated: true, completion: nil)
        }
    }
    
    func contactTouched() {
                
        DispatchQueue.main.async { [weak self] in
            self?.present(ContactUsViewController(), animated: true, completion: nil)
        }
        
    }
    
    func donateTouched() {

        guard let url = URL(string: "https://magr.org/donate/") else {return}
        
        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url, options: [:]) }
    }
    
    func feedbackTouched() {
        DispatchQueue.main.async { [weak self] in
            self?.present(FeedbackViewController(), animated: true, completion: nil)
        }
    }

    
}

// MARK: Jumaa Handling
extension HomeVC {
    
    private func shouldPresent() {
        let currentDate = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate) // Sunday = 1, Monday = 2, etc.
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)
        let rawJumaaTime = TimeManager.createDateFromTime(DataManager.jumaaToday.iqama)
        let jumaaHour = calendar.component(.hour, from: rawJumaaTime ?? Date())
        let jumaaMinute = calendar.component(.minute, from: rawJumaaTime ?? Date())

        if weekday == 6 && currentHour <= jumaaHour && currentMinute <= jumaaMinute { // Check if it's Monday
            presentJumaaAlert()
        }
    }
    
    private func presentJumaaAlert() {
        let alertController = UIAlertController(
            title: "Jumaa Mubarak!",
            message: "Learn the Jumaa Sunnah",
            preferredStyle: .alert
        )

        // "Yes" action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.presentJumaaImageScreen()
        }

        // "Not Now" action
        let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(notNowAction)

        AlertManager.shared.addAlert(alertController)
    }
    
    private func presentJumaaImageScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.present(JumaaImageViewController(), animated: true, completion: nil)
        }
    }

}
