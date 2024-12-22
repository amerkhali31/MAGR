//
//  HadithViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import UIKit

/**
 The View Controller that should pop up when you click verse of the day. Displays the results of hadith api
 */
class HadithViewController: BaseBackgroundViewController {
    
    var apiResponse: APIResponse?
    
    private let dragHandle = UIView()
    private let narratorLabel = UILabel()
    private let hadithNumberLabel = UILabel()
    private let hadithLabel = UILabel()
    private let bookLabel = UILabel()
    private let chapterLabel = UILabel()
    private let volumeLabel = UILabel()
    private let scrollView = UIScrollView() // Add a UIScrollView to contain the hadithLabel
    private let contentView = UIView()     // Content view for the scroll view
    
    private var narrator: String = ""
    private var hadithNumber: String = ""
    private var hadith: String = ""
    private var book: String = ""
    private var chapter: String = ""
    private var volume: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processApiResponse()
        setupLabels()
        setupDragHandle()
    }
    
    func processApiResponse() {
        guard let safeResponse = apiResponse,
              let safeHadiths = safeResponse.hadiths,
              let safeData = safeHadiths.data,
              let safeHadith = safeData.first else { return }
        
        narrator = safeHadith?.englishNarrator ?? "Narrator N/A"
        hadithNumber = safeHadith?.hadithNumber ?? "Hadith Number N/A"
        hadith = safeHadith?.hadithEnglish ?? "Hadith N/A"
        book = safeHadith?.bookSlug ?? "Book N/A"
        chapter = safeHadith?.chapter?.chapterEnglish ?? "Chapter N/A"
        volume = safeHadith?.volume ?? "Volume N/A"
    }
    
    func setupLabels() {
        bookLabel.text = "Book: \(book), Volume: \(volume), Chapter: \(chapter), Hadith Number: \(hadithNumber)"
        initLabel(bookLabel, view.topAnchor, yInset: self.bottomOfImage + 15)
        
        narratorLabel.text = "Narrator: \(narrator)"
        initLabel(narratorLabel, bookLabel.bottomAnchor)
        
        // Configure the scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: narratorLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add the hadith label to the content view
        hadithLabel.text = hadith
        hadithLabel.numberOfLines = 0 // Allow unlimited lines
        hadithLabel.translatesAutoresizingMaskIntoConstraints = false
        hadithLabel.textColor = .white
        contentView.addSubview(hadithLabel)
        
        NSLayoutConstraint.activate([
            hadithLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hadithLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hadithLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hadithLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func initLabel(_ label: UILabel, _ below: NSLayoutYAxisAnchor, rows: Int = 0, height: CGFloat = 21, yInset: CGFloat = 20) {
        view.addSubview(label)
        
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.textAlignment = .left
        label.contentMode = .top
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = rows
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: below, constant: yInset),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func setupDragHandle() {
        dragHandle.backgroundColor = UIColor.lightGray
        dragHandle.layer.cornerRadius = 3
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dragHandle)
        
        NSLayoutConstraint.activate([
            dragHandle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dragHandle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 50),
            dragHandle.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}

