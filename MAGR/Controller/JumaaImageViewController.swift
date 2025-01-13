//
//  JumaaImageViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 1/13/25.
//

import UIKit

class JumaaImageViewController: BaseBackgroundViewController {
    let imageView = UIImageView()
    private let dragHandle = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
        setupDragHandle()
    }

    private func setupImageView() {
        imageView.image = UIImage(named: "jumaa_sunnah") // Replace with your image asset
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
