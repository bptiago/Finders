//
//  ContentView.swift
//  Finders
//
//  Created by Tiago Prestes on 19/01/26.
//

// TODO: Coordinator, app localization, permission screen, home, quiz

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject private var coordinator = Coordinator()
    @StateObject private var permissionManager = LocationPermissionManager()
    
    private var rootPage: Page {
        return permissionManager.isAuthorized ? .home : .permission
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: rootPage)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
//                .sheet(item: $coordinator.sheet) { sheet in
//                    coordinator.build(sheet: sheet)
//                }
        }
        .environmentObject(permissionManager)
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
