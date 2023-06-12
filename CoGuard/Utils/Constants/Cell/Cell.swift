//
//  Cell.swift
//  Fastfull
//
//  Created by عمرو on 4.01.2023.
//

import Foundation

enum Cell: Int, CaseIterable {
    case AuthFieldCell
    case MenuItemCell
    case ProfileDetailCell
    case ConditionCell
    case TravelInfoCell
    case GlobalStatCell
    case CountryStatCell
    case NewsCell
    case HospitalCell
    case ExaminationCardCell
    case SymptomCell
    case AttachmentCell
    case DoctorCell
    
    var name: String {
        switch self {
        case .AuthFieldCell:
            return "AuthFieldCell"
        case .MenuItemCell:
            return "MenuItemCell"
        case .ProfileDetailCell:
            return "ProfileDetailCell"
        case .ConditionCell:
            return "ConditionCell"
        case .TravelInfoCell:
            return "TravelInfoCell"
        case .GlobalStatCell:
            return "GlobalStatCell"
        case .CountryStatCell:
            return "CountryStatCell"
        case .NewsCell:
            return "NewsCell"
        case .HospitalCell:
            return "HospitalCell"
        case .ExaminationCardCell:
            return "ExaminationCardCell"
        case .SymptomCell:
            return "SymptomCell"
        case .AttachmentCell:
            return "AttachmentCell"
        case .DoctorCell:
            return "DoctorCell"
        }
    }
    
    var reuseIdentifier: String {
        switch self {
        case .AuthFieldCell:
            return "AuthFieldCell"
        case .MenuItemCell:
            return "MenuItemCell"
        case .ProfileDetailCell:
            return "ProfileDetailCell"
        case .ConditionCell:
            return "ConditionCell"
        case .TravelInfoCell:
            return "TravelInfoCell"
        case .GlobalStatCell:
            return "GlobalStatCell"
        case .CountryStatCell:
            return "CountryStatCell"
        case .NewsCell:
            return "NewsCell"
        case .HospitalCell:
            return "HospitalCell"
        case .ExaminationCardCell:
            return "ExaminationCardCell"
        case .SymptomCell:
            return "SymptomCell"
        case .AttachmentCell:
            return "AttachmentCell"
        case .DoctorCell:
            return "DoctorCell"
        }
    }
}
