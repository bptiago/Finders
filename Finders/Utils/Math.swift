//
//  Math.swift
//  Finders
//
//  Created by Tiago Prestes on 27/01/26.
//

import Foundation

struct Math {
    static func toRadians(_ degrees: Double) -> Double {
        return ( Double.pi * degrees) / 180
    }
    
    static func toDegrees(_ radians: Double) -> Double {
        return ( 180 * radians ) / Double.pi
    }
}
