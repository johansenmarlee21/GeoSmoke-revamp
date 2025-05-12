//
//  LocationManager.swift
//  GeoSmoke
//
//  Created by Ageng Tawang Aryonindito on 09/05/25.
//

import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    

    func requestLocationAccess() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location Services are disabled.")
        }
    }
    
    func requestUserLocation(completion: @escaping (CLLocation?) -> Void) {
        self.locationCompletion = completion
        locationManager.requestLocation()
    }
    
    private func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("Location access is restricted or denied.")
        @unknown default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        locationCompletion?(location)
        locationCompletion = nil // Prevent multiple calls
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }
}
