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

class GeospatialService {
    
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
    
    // Bearing Formula
    // https://www.movable-type.co.uk/scripts/latlong.html
    func calculateBearing(from point1: CLLocationCoordinate2D, to point2: CLLocationCoordinate2D) -> Double {
        let lat1 = Math.toRadians(point1.latitude)
        let long1 = Math.toRadians(point1.longitude)
        
        let lat2 = Math.toRadians(point2.latitude)
        let long2 = Math.toRadians(point2.longitude)
        
        let delta = long2 - long1
        let y = sin(delta) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(delta)
        let bearing = atan2(y, x)
        
        // Convert bearing from rad to degrees
        let result = (Math.toDegrees(bearing) + 360).truncatingRemainder(dividingBy: 360)
        return result
    }
    
}
