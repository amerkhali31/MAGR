//
//  ContactUsViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/15/24.
//

import UIKit

class ContactUsViewController: BaseBackgroundViewController {
    
    var apiResponse: APIResponse?
    
    private let dragHandle = UIView()
    
    private let addressStackView = UIStackView()
    private let phoneStackView = UIStackView()
    private let emailStackView = UIStackView()
    private let facebookStackView = UIStackView()
    private let twitterStackView = UIStackView()
    private let instagramStackView = UIStackView()
    private let youtubeStackView = UIStackView()
    
    private var address: String = "5921 Darlene Drive Rockford, IL 61109"
    private var phoneNumber: String = "815-397-3311"
    private var emailAddress: String = "admin@magr.org"
    private var facebook: String = "https://www.facebook.com/mccrockford/"
    private var twitter: String = "https://x.com/rockfordmuslim"
    private var instagram: String = "https://www.instagram.com/pr.magr/"
    private var youtube: String = "https://www.youtube.com/channel/UCR5A1w2CHgVzczONPABxOMQ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragHandle()
        setupStackViews()
    }
    
    func setupStackViews() {
        // Address
        configureStackView(addressStackView, icon: UIImage(systemName: "mappin")!, text: "Address: \(address)", color: .red) {
            self.openMap(for: self.address)
            
        }
        
        // Phone
        configureStackView(phoneStackView, icon: UIImage(systemName: "phone.fill")!, text: "Phone: \(phoneNumber)", color: .green) {
            self.callNumber(self.phoneNumber)
        }
        
        // Email
        configureStackView(emailStackView, icon: UIImage(systemName: "envelope.fill")!, text: "Email: \(emailAddress)") {
            self.sendEmail(to: self.emailAddress)
        }
        
        // Facebook
        configureStackView(facebookStackView, icon: UIImage(named: "facebook")!, text: "Facebook") {
            self.openWebPage(self.facebook)
        }
        
        // Twitter
        configureStackView(twitterStackView, icon: UIImage(named: "twitter")!, text: "Twitter") {
            self.openWebPage(self.twitter)
        }
        
        // Instagram
        configureStackView(instagramStackView, icon: UIImage(named: "instagram")!, text: "Instagram") {
            self.openWebPage(self.instagram)
        }
        
        // YouTube
        configureStackView(youtubeStackView, icon: UIImage(named: "youtube")!, text: "YouTube") {
            self.openWebPage(self.youtube)
        }
        
        // Arrange in vertical order
        let stackView = UIStackView(arrangedSubviews: [
            addressStackView,
            phoneStackView,
            emailStackView,
            facebookStackView,
            twitterStackView,
            instagramStackView,
            youtubeStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: bottomOfImage+15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func makeUnderlinedText(_ text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [:]
        )
    }
    
    func configureStackView(_ stackView: UIStackView, icon: UIImage, text: String, color: UIColor = .tintColor, action: @escaping () -> Void) {
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        if color != UIColor.tintColor {
            imageView.tintColor = color
        }

        // Create a container for the label to provide padding
        let labelContainer = UIView()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.attributedText = makeUnderlinedText(text)
        label.textColor = .tintColor
        label.font = UIFont(name: "Helvetica Neue", size: 24)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true

        // Add tap gesture to label
        addTapGesture(to: label, action: action)

        label.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.addSubview(label)

        // Add padding to the label within the container
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: 5), // Top padding
            label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -5) // Bottom padding
        ])

        let linkIconView = UIImageView(image: UIImage(systemName: "link"))
        linkIconView.contentMode = .scaleAspectFit
        linkIconView.translatesAutoresizingMaskIntoConstraints = false
        linkIconView.tintColor = .tintColor
        linkIconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        linkIconView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Wrap the link icon in a container view for padding
        let linkIconContainer = UIView()
        linkIconContainer.translatesAutoresizingMaskIntoConstraints = false
        linkIconContainer.addSubview(linkIconView)
        linkIconContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
        linkIconContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Center the link icon within the container
        NSLayoutConstraint.activate([
            linkIconView.centerXAnchor.constraint(equalTo: linkIconContainer.centerXAnchor),
            linkIconView.centerYAnchor.constraint(equalTo: linkIconContainer.centerYAnchor)
        ])

        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(labelContainer) // Use the label container instead of the label directly
        stackView.addArrangedSubview(linkIconContainer) // Add the container for the link icon
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.borderWidth = 2
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 5
    }



    
    func addTapGesture(to label: UILabel, action: @escaping () -> Void) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        label.addGestureRecognizer(tap)
        objc_setAssociatedObject(label, &actionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel,
           let action = objc_getAssociatedObject(label, &actionKey) as? () -> Void {
            action()
        }
    }
    
    func openMap(for address: String) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(encodedAddress)") {
            UIApplication.shared.open(url)
        }
    }
    
    func callNumber(_ number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func openWebPage(_ urlString: String) {
        if let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
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

private var actionKey: UInt8 = 0
