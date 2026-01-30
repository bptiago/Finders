//
//  Page.swift
//  Finders
//
//  Created by Tiago Prestes on 29/01/26.
//

import Foundation

enum Page: String, Identifiable {
    case permission, home
    
    var id: String {
        self.rawValue
    }
}

//enum Sheet: String, Identifiable {
//    case permission, home
//    
//    var id: String {
//        self.rawValue
//    }
//}
