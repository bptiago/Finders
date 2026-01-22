//
//  MapKitService.swift
//  Finders
//
//  Created by Tiago Prestes on 19/01/26.
//

import Combine
import Foundation
import CoreLocation
import MapKit

class MapKitService {
    
    private let KILOMETERS_PER_DEGREE: Double = 111.111
    private let SEARCH_RADIUS: Double = 5 // km
    private let SPACE_BETWEEN_POINTS: Double = 0.02 // degrees
    
    // Define even spaced points by coordinates
    func getGeographicalPoints(center: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        var points: [CLLocationCoordinate2D] = []
        
        let deltaLat = SEARCH_RADIUS / KILOMETERS_PER_DEGREE
        let deltaLong = SEARCH_RADIUS / (KILOMETERS_PER_DEGREE * cos(center.latitude * .pi / 180))
        
        // Bounding Box
        let maxLat = center.latitude + deltaLat
        let minLat = center.latitude - deltaLat
        let maxLong = center.longitude + deltaLong
        let minLong = center.longitude - deltaLong
        
        // reads X axis, updates Y axis, then repeats
        for lat in stride(from: maxLat, through: minLat, by: -SPACE_BETWEEN_POINTS) {
            for lon in stride(from: minLong, through: maxLong, by: SPACE_BETWEEN_POINTS) {
                let nextPoint = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                points.append(nextPoint)
            }
        }
                
        return points
    }
    
    func reverseGeocodePoint(point: CLLocationCoordinate2D) async throws -> CLPlacemark {
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        if #available(iOS 26, *) {
            let request = MKReverseGeocodingRequest(location: location)
            guard let request else { throw LocationException.unableToMakeRequest }
            let items = try await request.mapItems
            
            guard let reverseGeocodedPoint = items.first else {
                throw LocationException.noLocationFound
            }
            
            return reverseGeocodedPoint.placemark
            
        } else {
            let geocoder = CLGeocoder()
            let items = try await geocoder.reverseGeocodeLocation(location)
            
            guard let reverseGeocodedPoint = items.first else {
                throw LocationException.noLocationFound
            }
            
            return reverseGeocodedPoint
        }
    }
    
    // Check if phone is aimed towards a point
    // Need to find the angle between two points:
    // Draw points by coordinate
    // 
    
    func test(center: CLLocationCoordinate2D) {
        let points = getGeographicalPoints(center: center)
        
        do {
            points.forEach { i in
                Task {
                    let result = try await reverseGeocodePoint(point: i)
                    print(result.subLocality ?? "")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAddressFromPOI(POI: CLPlacemark) {
        let neighborhood = POI.subLocality
        print(neighborhood ?? "no")
    }
    
    func searchPOIs(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let request = MKLocalSearch.Request(naturalLanguageQuery: "Restaurants", region: region)
        
//        request.pointOfInterestFilter = .init(including: [.airport, .hospital, .museum, .restaurant, .university])
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            response?.mapItems.forEach { item in
                print(item.url ?? "No URL")
                print(item.name ?? "No Name")
            }
        }
    }
    
}
