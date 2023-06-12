//
//  RegistertionDetail.swift
//  CoGuard
//
//  Created by عمرو on 17.05.2023.
//

import UIKit

enum RegistertionDetail: Int, CaseIterable, UserDetail {
    case fullname
    case birthdate
    case sex
    case hospital
    case speciality
    case email
    case password
    
    var id: Int {
        rawValue
    }
    
    var title: String {
        switch self {
        case .fullname:
            return "Name"
        case .birthdate:
            return "Birthdate"
        case .sex:
            return "Sex"
        case .hospital:
            return "Hospital"
        case .speciality:
            return "Speciality"
        case .email:
            return "Email"
        case .password:
            return "Password"
        }
    }
    
    var img: UIImage? {
        switch self {
        case .fullname:
            return UIImage(named: Asset.person) ?? UIImage()
        case .birthdate:
            return UIImage(named: Asset.calendar) ?? UIImage()
        case .sex:
            return UIImage(named: Asset.gender) ?? UIImage()
        case .hospital:
            return UIImage(named: Asset.hospital) ?? UIImage()
        case .speciality:
            return UIImage(named: Asset.specialty) ?? UIImage()
        case .email:
            return UIImage(named: Asset.envelope) ?? UIImage()
        case .password:
            return UIImage(named: Asset.lock) ?? UIImage()
        }
    }
    
    var dataType: TextFieldEntryDataType {
        switch self {
        case .fullname:
            return .text
        case .birthdate:
            return .date
        case .sex:
            return .picker
        case .hospital:
            return .picker
        case .speciality:
            return .picker
        case .email:
            return .email
        case .password:
            return .password
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

        case .hospital:
            var hospitals = [String]()
            for case let hospital in Hospital.allCases {
                hospitals.append(hospital.title)
            }
            return hospitals
            
        case .speciality:
            var specialities = [String]()
            for case let speciality in Specialty.allCases {
                specialities.append(speciality.title)
            }
            return specialities
            
        default:
            return nil
        }
    }
}
