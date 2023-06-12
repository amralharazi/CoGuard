//
//  CaseLocation.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation
import CoreLocation

struct CaseLocation {
    var latitude: Double?
    var longitude: Double?
    var coordinates: CLLocationCoordinate2D?
    
    init(dictionary: [String: Any]) {
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        if let latitude = latitude, let longitude = longitude {
            self.coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
}
