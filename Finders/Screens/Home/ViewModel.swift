//
//  ViewModel.swift
//  Finders
//
//  Created by Tiago Prestes on 27/01/26.
//

import Foundation
import Combine
import CoreLocation

class ViewModel: ObservableObject {
    private var geospatialService: GeospatialService
    private var locationService: LocationService
    
    @Published var points: [CLLocationCoordinate2D] = [] // Should be placemark or other
    
    init(
        locationService: LocationService = LocationService(),
        geospatialService: GeospatialService = GeospatialService()
    ) {
        self.locationService = locationService
        self.geospatialService = geospatialService
    }
    
    func getPoints() {
        guard let location = locationService.location else {
            NSLog("No location loaded")
            return
        }
        
        let points = geospatialService.getGeographicalPoints(center: location.coordinate)
        
        if points.isEmpty {
            NSLog("No points drawed")
            return
        }
        
        
    }
    
    private func isHeadingToPoint(heading: CLHeading, bearing: Double) -> Bool {
        let tolerance: Double = 10.0 // degrees
        let delta = abs(heading.trueHeading - bearing) // degrees
        
        var adjustedDelta = delta.truncatingRemainder(dividingBy: 360)
        
        // Converts to 180 : -180 interval
        // e.g  -350 = -10 degrees North
        if adjustedDelta > 180 { adjustedDelta -= 360 }
        if adjustedDelta < -180 { adjustedDelta += 360 }
        
        // CLLocation bearing reads negative numbers as undetermined
        return abs(adjustedDelta) <= tolerance
    }
    
//    private func getAddressFromPOI(POI: CLPlacemark) {
//        let neighborhood = POI.subLocality
//        print(neighborhood ?? "no")
//    }
//
}
