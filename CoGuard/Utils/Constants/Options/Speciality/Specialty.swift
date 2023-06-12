//
//  Speciality.swift
//  CoGuard
//
//  Created by عمرو on 18.05.2023.
//

import Foundation

enum Specialty: Int, CaseIterable {
    case respiratoryMedicine
    case cardiology
    case renalMedicine
    case respiratory
    case endocrinologyAndDiabetes
    case geriatricMedicine
    case generalPractice
    case pulmonology
    
    var title: String {
        switch self {
        case .respiratoryMedicine:
            return "Respiratory Medicine"
        case .cardiology:
            return "Cardiology"
        case .renalMedicine:
            return "Renal Medicine"
        case .respiratory:
            return "Respiratory"
        case .endocrinologyAndDiabetes:
            return "Endocrinology and Diabetes"
        case .geriatricMedicine:
            return "Geriatric Medicine"
        case .generalPractice:
            return "General Practice"
        case .pulmonology:
            return "Pulmonology"  
        }
    }
}
