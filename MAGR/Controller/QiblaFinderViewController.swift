//
//  QiblaFinderViewController.swift
//  MAGR
//
//  Created by Amer Khalil on 12/16/24.
//
import UIKit
import CoreLocation

class QiblaFinderViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let kaabaCoordinates = CLLocation(latitude: 21.4225, longitude: 39.8262) // Kaaba's location
    
    private var userHeading: CLLocationDirection = 0.0
    private var qiblaDirection: CLLocationDirection = 0.0

    private let compassView = UIImageView(image: UIImage(systemName: "location.north.fill")) // Use SF Symbol
    private let arrowView = UIImageView(image: UIImage(systemName: "arrow.up")) // Qibla direction arrow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupLocationManager()
    }
    
    private func setupUI() {
        // Add Compass View
        compassView.tintColor = .gray
        compassView.translatesAutoresizingMaskIntoConstraints = false
        compassView.contentMode = .scaleAspectFit
        view.addSubview(compassView)
        
        // Add Arrow View (Qibla Direction)
        arrowView.tintColor = .green
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.contentMode = .scaleAspectFit
        view.addSubview(arrowView)
        
        // Constraints
        NSLayoutConstraint.activate([
            compassView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compassView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            compassView.widthAnchor.constraint(equalToConstant: 200),
            compassView.heightAnchor.constraint(equalToConstant: 200),
            
            arrowView.centerXAnchor.constraint(equalTo: compassView.centerXAnchor),
            arrowView.centerYAnchor.constraint(equalTo: compassView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 50),
            arrowView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    private func calculateQiblaDirection(from userLocation: CLLocation) {
        let userLatitude = userLocation.coordinate.latitude.degreesToRadians
        let userLongitude = userLocation.coordinate.longitude.degreesToRadians
        let kaabaLatitude = kaabaCoordinates.coordinate.latitude.degreesToRadians
        let kaabaLongitude = kaabaCoordinates.coordinate.longitude.degreesToRadians
        
        // Calculate Qibla direction using the formula
        let deltaLongitude = kaabaLongitude - userLongitude
        let x = cos(kaabaLatitude) * sin(deltaLongitude)
        let y = cos(userLatitude) * sin(kaabaLatitude) - sin(userLatitude) * cos(kaabaLatitude) * cos(deltaLongitude)
        qiblaDirection = atan2(x, y).radiansToDegrees
        if qiblaDirection < 0 { qiblaDirection += 360 } // Ensure direction is positive
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        calculateQiblaDirection(from: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        updateCompass()
    }
    
    private func updateCompass() {
        let qiblaAngle = qiblaDirection - userHeading
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(qiblaAngle.degreesToRadians))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error.localizedDescription)")
    }
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}
