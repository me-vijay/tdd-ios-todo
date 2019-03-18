//
//  Location.swift
//  ToDo
//
//  Created by vijay on 16/12/2018.
//  Copyright © 2018 vijay. All rights reserved.
//

import Foundation
import CoreLocation

struct Location : Equatable {
    let name: String
    let coordinates: CLLocationCoordinate2D?
    
    init(name: String,
         coordinates: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinates = coordinates
    }
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        if lhs.coordinates?.latitude != rhs.coordinates?.latitude {
            return false
        }
        if lhs.coordinates?.longitude != rhs.coordinates?.longitude {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        return true
    }
}
