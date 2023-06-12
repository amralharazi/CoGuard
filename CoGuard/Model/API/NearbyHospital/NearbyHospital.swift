//
//  NearbyHospital.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation
import CoreLocation

struct NearbyHospital {
    var name: String
    var city: String
    var latitude: Double
    var longitude: Double
    var image: URL?
    var currentCases: Int
    var criticalCases: Int
    var deaths: Int
    var totalCases: Int
    var recovered: Int
    var location: CLLocation
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 1
        self.longitude = dictionary["longitude"] as? Double ?? 1
        if let url = dictionary["image"] as? String {
            self.image = URL(string: url)
        }
        self.currentCases = dictionary["currentCases"] as? Int ?? 0
        self.criticalCases = dictionary["criticalCases"] as? Int ?? 0
        self.deaths = dictionary["deaths"] as? Int ?? 0
        self.totalCases = dictionary["totalCases"] as? Int ?? 0
        self.recovered = dictionary["recovered"] as? Int ?? 0
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}
