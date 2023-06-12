//
//  CompleteProfileDetail.swift
//  CoGuard
//
//  Created by عمرو on 25.05.2023.
//

import UIKit

enum CompleteProfileDetail: Int, CaseIterable, UserDetail {
    case weight
    case height
    case city
    case status
    case phone
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .weight:
            return "Weight"
        case .height:
            return "Height"
        case .city:
            return "City"
        case .status:
            return "Marital Status"
        case .phone:
            return "Mobile Number"   
        }
    }
    
    var databaseKey: String {
        switch self {
        case .weight:
            return "weight"
        case .height:
            return "height"
        case .city:
            return "city"
        case .status:
            return "status"
        case .phone:
            return "phone"
        }
    }
        
    var img: UIImage? {
        switch self {
        case .weight:
            return UIImage(named: Asset.scale) ?? UIImage()
        case .height:
            return UIImage(named: Asset.hieght) ?? UIImage()
        case .city:
            return UIImage(named: Asset.pin) ?? UIImage()
        case .status:
            return UIImage(named: Asset.rings) ?? UIImage()
        case .phone:
            return UIImage(named: Asset.phone) ?? UIImage()
        }
    }
    
    var dataType: TextFieldEntryDataType {
        switch self {
        case .weight, .height, .city, .status:
            return .picker
        case .phone:
            return .phone
        }
    }
    
    var options: [String]? {
        switch self {
        case .weight:
            var weights = [String]()
            for i in 2..<200 {
                weights.append("\(i) kg")
            }
            return weights
            
        case .height:
            var heights = [String]()
            for i in 40..<250 {
                heights.append("\(i) cm")
            }
            return heights
            
        case .status:
            var statuses = [String]()
            for case let status in MaritalStatus.allCases {
                statuses.append(status.title)
            }
            return statuses
            
        case .city:
            var cities = [String]()
            for case let city in City.allCases {
                cities.append(city.title)
            }
            return cities
            
        default:
            return nil
        }
    }
}
