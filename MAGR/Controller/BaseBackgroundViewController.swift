//
//  BaseBackgroundViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

/**
 The View Controller the entire app uses
 - Note: Provides consistent look and feel with gradient background and logo at the top of each page
 - Note: Provides location of bottom of logo image so pages can accurately place their objects without interference
 */
class BaseBackgroundViewController: UIViewController {
    
    var bottomOfImage: CGFloat = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        
        setupGradientBackground()
        addLogo()

    }
    
    private func addLogo() {
        
        let topOfImage: CGFloat = 55
        let heightOfImage: CGFloat = 50
        bottomOfImage = topOfImage + heightOfImage
        
        let loadingImageView = UIImageView()
        let loadingImage = UIImage(named: K.images.logo)
        
        loadingImageView.image = loadingImage
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.contentMode = .scaleAspectFit
        view.addSubview(loadingImageView)
        
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 50),
            loadingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: topOfImage),
            loadingImageView.heightAnchor.constraint(equalToConstant: heightOfImage)
        ])        
    }

    private func setupGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.new.cgColor,    // Start color
            UIColor.MAGR_4.cgColor    // End color
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top-left
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)   // Bottom-right
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
       
    }

}
