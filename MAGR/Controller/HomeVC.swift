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
    let announcementBox = HomeBox()
    let verseBox = HomeBox()
    let contactBox = HomeBox()
    let donationBox = HomeBox()
    
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
        
        dateLabel.text = "December 1st 1999"
        arabDateLabel.text = "Some Lunar Calendar Date"
        
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
        
        prayerBox.configure(icon: UIImage(systemName: "moon.stars"), topText: "Next Prayer", countdownText: "05:49:10")
        prayerBox.attachTo(parentView: contentView, topAnchor: arabDateLabel.bottomAnchor, topInset: standardSpace, xInset: standardXinset, height: 150)
    
        announcementBox.configure(icon: UIImage(systemName: "bell"), topText: "Announcements", bottomText: "Stay up to date with MAGR news")
        announcementBox.attachTo(parentView: contentView, topAnchor: prayerBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
    
        verseBox.configure(icon: UIImage(systemName: "book"), topText: "Verse of the Day", bottomText: "Reflect on the wisdom of the Quran")
        verseBox.attachTo(parentView: contentView, topAnchor: announcementBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
    
        contactBox.configure(icon: UIImage(systemName: "phone"), topText: "Contact Us", bottomText: "Find all of our contact information")
        contactBox.attachTo(parentView: contentView, topAnchor: verseBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        
        donationBox.configure(icon: UIImage(systemName: "dollarsign.circle"), topText: "Donate", bottomText: "Increase in charity")
        donationBox.attachTo(parentView: contentView, topAnchor: contactBox.bottomAnchor, topInset: standardSpace, xInset: standardXinset)
        
        donationBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    
}
