//
//  SettingsBox.swift
//  MAGR
//
//  Created by Amer Khalil on 1/12/25.
//

import UIKit

class SettingsBox: UIView {
    
    var onTouch: (() -> Void)?
    
    
    // MARK: - Initializer
    init(title: String, description: String) {
        super.init(frame: .zero)
        setupView(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Private Methods
    private func setupView(title: String, description: String) {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        //self.layer.shadowRadius = 4
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func handleTap() {onTouch?()}
    
    
    // MARK: Public Methods
    func attachTo(parentView: UIView, topAnchor: NSLayoutYAxisAnchor, topInset: CGFloat = 20, height: CGFloat = 60, xInset: CGFloat = 10) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            self.heightAnchor.constraint(equalToConstant: height),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: xInset),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -xInset)
            
        ])
    }

}
