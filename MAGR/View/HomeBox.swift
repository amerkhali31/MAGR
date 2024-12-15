//
//  HomeBox.swift
//  MAGR
//
//  Created by Amer Khalil on 12/13/24.
//

import UIKit

class HomeBox: UIView {
    
    var onTouch: (() -> Void)?
    
    // MARK: - UI Elements
    let iconView = UIImageView()
    let topLabel = UILabel()
    let bottomLabel = UILabel()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupIcon()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupIcon()
        setupLabels()
    }

    // MARK: - Setup Methods
    private func setupView() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
            onTouch?() // Call the closure when tapped
    }
    
    private func setupIcon() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemGreen
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupLabels() {
        topLabel.font = UIFont.boldSystemFont(ofSize: 30)
        topLabel.textColor = .white
        topLabel.translatesAutoresizingMaskIntoConstraints = false

        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textColor = .lightGray
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }

    // MARK: - Public Configuration Methods
    func configure(icon: UIImage?, topText: String, bottomText: String) {
        iconView.image = icon
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
    
    func attachTo(parentView: UIView, topAnchor: NSLayoutYAxisAnchor, topInset: CGFloat = 10, xInset: CGFloat = 10, height: CGFloat = 100) {
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: xInset),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -xInset),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

class PrayerBox: UIView {
    
    var onTouch: (() -> Void)?
    
    // MARK: - UI Elements
    private let iconView = UIImageView()
    let topLabel = UILabel()
    let countdownLabel = UILabel()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupIcon()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupIcon()
        setupLabels()
    }

    // MARK: - Setup Methods
    private func setupView() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func handleTap() {
            onTouch?() // Call the closure when tapped
    }


    private func setupIcon() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemGreen
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupLabels() {
        // Configure the top label
        topLabel.font = UIFont.boldSystemFont(ofSize: 36)
        topLabel.textColor = .white
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            topLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
        
        // Configure the countdown label
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 44)
        countdownLabel.textColor = UIColor(named: "magr1") ?? .systemGreen
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
            countdownLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            countdownLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            countdownLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }

    // MARK: - Public Configuration Methods
    func configure(icon: UIImage?, topText: String, countdownText: String) {
        iconView.image = icon
        topLabel.text = topText
        countdownLabel.text = countdownText
    }

    func updateCountdownText(_ text: String) {
        countdownLabel.text = text
    }
    
    // Convenience method to add constraints in one line
    func attachTo(parentView: UIView, topAnchor: NSLayoutYAxisAnchor, topInset: CGFloat = 10, xInset: CGFloat = 10, height: CGFloat = 100) {
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: xInset),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -xInset),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

