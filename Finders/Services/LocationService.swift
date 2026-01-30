//
//  LocationService.swift
//  Finders
//
//  Created by Tiago Prestes on 19/01/26.
//

import Combine
import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.headingFilter = 5.0 // heading update trigger
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
            manager.startUpdatingHeading()
            break
            
        default:
            NSLog("Location permission not granted, status: \(manager.authorizationStatus)")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Set up tolerance for updating header
        heading = newHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        location = lastLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // MARK: Airplane mode etc.
        print("Error: \(error.localizedDescription)")
    }
    
}
