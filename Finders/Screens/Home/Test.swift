//
//  Test.swift
//  Finders
//
//  Created by Tiago Prestes on 22/01/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct Test: View {
    @State var camera: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State var points: [CLLocationCoordinate2D] = []

    let l = LocationService()
    let m = GeospatialService()
    
    var body: some View {
        Map(position: $camera) {
            UserAnnotation()
            
            ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                Marker("Ponto \(index + 1)", coordinate: point)
                    .tint(.blue)
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Button("test") {
                guard let location = l.location else { return }
                
                let points = m.getGeographicalPoints(center: location.coordinate)
                self.points = points
                
//                m.test(center: location.coordinate)
            }
        })
    }
}

#Preview {
    Test()
}
