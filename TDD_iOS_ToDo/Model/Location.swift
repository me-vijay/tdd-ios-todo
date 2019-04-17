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
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    
    var plistDictionary: [String:Any] {
        var dict = [String:Any]()
        dict[nameKey] = name
        if let coords = coordinates {
            dict[latitudeKey] = coords.latitude
            dict[longitudeKey] = coords.longitude
        }
        return dict
    }
    
    init(name: String,
         coordinates: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinates = coordinates
    }
    
    init?(dictionary: [String:Any]) {
        guard let nam = dictionary[nameKey] as? String else { return nil }
        let coords: CLLocationCoordinate2D?
        
        if let lat = dictionary[latitudeKey] as? Double, let lng = dictionary[longitudeKey] as? Double  {
            coords = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            coords = nil
        }
        self.name = nam
        self.coordinates = coords
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
