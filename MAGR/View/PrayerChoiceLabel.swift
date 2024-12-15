//
//  PrayerChoiceLabel.swift
//  MAGR
//
//  Created by Amer Khalil on 12/14/24.
//

import UIKit

class PrayerChoiceLabel: UILabel {
    
    var onTap: (() -> Void)?
    
    var selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .font: UIFont.boldSystemFont(ofSize: 28),
        .foregroundColor: UIColor.white]
    var deselectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 28),
        .foregroundColor: UIColor.black]
    
    // For PrayerChoiceLabel(frame:) implementation
    override init(frame: CGRect) {
       super.init(frame: frame)
    }
   
    // For IBOutlet implementation
    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    // For setting up the way I intended
    init(text: String, status: Bool) {
        
        super.init(frame: .zero)
        
        var attributedText = NSAttributedString()
        if status {attributedText = NSAttributedString(string: text, attributes: selectedTextAttributes)}
        else {attributedText = NSAttributedString(string: text, attributes: deselectedTextAttributes)}
        self.attributedText = attributedText
        self.textAlignment = .center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        self.isUserInteractionEnabled = true
        attributedText = NSAttributedString(string: text, attributes: selectedTextAttributes)
        
    }
    
    func wasTapped() {
        self.attributedText = NSAttributedString(string: self.text!, attributes: selectedTextAttributes)
    }
    
    func wasntTapped() {
        self.attributedText = NSAttributedString(string: self.text!, attributes: deselectedTextAttributes)
    }

    func attachTo(parentView: UIView, topAnchor: NSLayoutYAxisAnchor, topInset: CGFloat = 5, height: CGFloat = 60, lead: NSLayoutXAxisAnchor) {
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            self.leadingAnchor.constraint(equalTo: lead),
            self.widthAnchor.constraint(equalToConstant: parentView.bounds.width / 2),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    @objc private func handleTap() {
            onTap?()
    }
    
}
