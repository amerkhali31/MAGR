//
//  BaseBackgroundViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import UIKit

class BaseBackgroundViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupGradientBackground()
        addLogo()
    }
    
    private func addLogo() {
        
        let loadingImageView = UIImageView()
        let loadingImage = UIImage(named: K.images.logo)
        
        loadingImageView.image = loadingImage
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.contentMode = .scaleAspectFit
        view.addSubview(loadingImageView)
        
        NSLayoutConstraint.activate([
            loadingImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 50),
            loadingImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

    private func setupGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.magr1.cgColor,    // Start color
            UIColor.MAGR_2.cgColor,
            UIColor.MAGR_2.cgColor,
            UIColor.MAGR_3.cgColor,
            UIColor.MAGR_3.cgColor,
            UIColor.MAGR_4.cgColor,
            UIColor.MAGR_4.cgColor    // End color
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top-left
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)   // Bottom-right
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

}
