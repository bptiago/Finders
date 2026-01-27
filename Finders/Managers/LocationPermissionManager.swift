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
    
    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var isAuthorized: Bool = false
    @Published var isDenied: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        status = manager.authorizationStatus
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        status = manager.authorizationStatus
        
        withAnimation {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                isAuthorized = true
                isDenied = false
                
            case .denied, .restricted:
                isAuthorized = false
                isDenied = true
                
            case .notDetermined:
                isAuthorized = false
                isDenied = false
                
            default:
                break
            }
        }
    }
}
