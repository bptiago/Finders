//
//  LocationException.swift
//  Finders
//
//  Created by Tiago Prestes on 21/01/26.
//

import Foundation

enum LocationException: Error {
    case unableToMakeRequest
    case noLocationFound
}
