//
//  PermissionManager.swift
//  Finders
//
//  Created by Tiago Prestes on 27/01/26.
//

import CoreLocation
import SwiftUI
import Combine

class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var status: CLAuthorizationStatus
    
    var isDenied: Bool {
        return status == .denied || status == .restricted
    }
    
    var isAuthorized: Bool {
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    override init() {
        status = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func redirectToSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        withAnimation {
            status = manager.authorizationStatus
        }
    }
}

extension LocationPermissionManager {
    static func isAuthorized() -> Bool {
        let manager = CLLocationManager()
        let status = manager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
}
