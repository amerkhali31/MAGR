//
//  HadithViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import UIKit

class HadithViewController: BaseBackgroundViewController {
    
    var apiResponse: APIResponse?
    
    private let dragHandle = UIView()
    
    private let narratorLabel = UILabel()
    private let hadithNumberLabel = UILabel()
    private let hadithLabel = UILabel()
    private let bookLabel = UILabel()
    private let chapterLabel = UILabel()
    private let volumeLabel = UILabel()
    
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
        
        guard let safeResponse = apiResponse else {return}
        guard let safeHadiths = safeResponse.hadiths else {return}
        guard let safeData = safeHadiths.data else {return}
        guard let safeHadith = safeData[0] else {return}
        
        narrator = safeHadith.englishNarrator ?? "Narrator N/A"
        hadithNumber = safeHadith.hadithNumber ?? "Hadith Number N/A"
        hadith = safeHadith.hadithEnglish ?? "Hadith N/A"
        book = safeHadith.bookSlug ?? "Book N/A"
        chapter = safeHadith.chapter?.chapterEnglish ?? "Chapter N/A"
        volume = safeHadith.volume ?? "Volume N/A"
        
    }
    
    func setupLabels() {
        
        bookLabel.text = "Book: \(book), Volume: \(volume), Chapter: \(chapter), Hadith Number: \(hadithNumber)"
        initLabel(bookLabel, view.topAnchor, yInset: self.bottomOfImage+15)
        
        narratorLabel.text = "Narrator: \(narrator)"
        initLabel(narratorLabel, bookLabel.bottomAnchor)
        
        hadithLabel.text = "\(hadith)"
        initLabel(hadithLabel, narratorLabel.bottomAnchor)
        
        
        
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
            // Configure the drag handle view
            dragHandle.backgroundColor = UIColor.lightGray
            dragHandle.layer.cornerRadius = 3
            dragHandle.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(dragHandle)
            
            // Set constraints for the drag handle
            NSLayoutConstraint.activate([
                dragHandle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                dragHandle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dragHandle.widthAnchor.constraint(equalToConstant: 50),
                dragHandle.heightAnchor.constraint(equalToConstant: 5)
            ])
        }

}
