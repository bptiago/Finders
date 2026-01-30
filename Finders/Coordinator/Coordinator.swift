//
//  Coordinator.swift
//  Finders
//
//  Created by Tiago Prestes on 29/01/26.
//

import Foundation
import Combine
import SwiftUI

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
//    @Published var sheet: Sheet?

    func push(_ page: Page) {
        path.append(page)
    }
    
//    func present(sheet: Sheet) {
//        self.sheet = sheet
//    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
//    func dismissSheet() {
//        self.sheet = nil
//    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .permission:
            PermissionView()
        case .home:
            HomeView()
        }
    }
    
//    @ViewBuilder
//    func build(sheet: Sheet) -> some View {
//        switch sheet {
//        case .permission:
//            ContentView()
//        case .home:
//            ContentView()
//        }
//    }

}
