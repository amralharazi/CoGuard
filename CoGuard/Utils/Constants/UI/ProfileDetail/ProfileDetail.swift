//
//  ProfileDetail.swift
//  CoGuard
//
//  Created by عمرو on 20.05.2023.
//

import UIKit

enum ProfileDetail: Int, CaseIterable, UserDetail {    
    
    case name
    case birthdate
    case sex
    case weight
    case height
    case maritalStatus
    case hospital
    case specialty
    case city
    case phone
    
    var id: Int {rawValue}
    
    var img: UIImage? {nil}
    
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .birthdate:
            return "Birthdate"
        case .sex:
            return "Sex"
        case .weight:
            return "Weight"
        case .height:
            return "Height"
        case .maritalStatus:
            return "Status"
        case .hospital:
            return "Hospital"
        case .specialty:
            return "Specialty"
        case .city:
            return "City"
        case .phone:
            return "Phone"
        }
    }
    
    var dataType: TextFieldEntryDataType {
        switch self {
        case .name:
            return .text
        case .birthdate:
            return .date
        case .sex, .weight, .height, .maritalStatus, .hospital, .specialty, .city:
            return .picker
        case .phone:
            return .phone
        }
    }
    
    var options: [String]? {
        switch self {
        case .sex:
            var sexes = [String]()
            for case let sex in Sex.allCases {
                sexes.append(sex.title)
            }
            return sexes
            
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
            
        case .maritalStatus:
            var statuses = [String]()
            for case let status in MaritalStatus.allCases {
                statuses.append(status.title)
            }
            return statuses
            
        case .hospital:
            var hospitals = [String]()
            for case let hospital in Hospital.allCases {
                hospitals.append(hospital.title)
            }
            return hospitals
            
        case .specialty:
            var specialities = [String]()
            for case let speciality in Specialty.allCases {
                specialities.append(speciality.title)
            }
            return specialities
            
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
