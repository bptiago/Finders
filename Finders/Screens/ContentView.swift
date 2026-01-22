//
//  ContentView.swift
//  Finders
//
//  Created by Tiago Prestes on 19/01/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View { 
    let l = LocationService()
    let m = MapKitService()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Hello") {
                guard let location = l.location else { return }
                m.test(center: location.coordinate)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
