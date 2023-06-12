//
//  Hospital.swift
//  CoGuard
//
//  Created by عمرو on 17.05.2023.
//

import Foundation

enum Hospital: Int, CaseIterable {
    case nearEast
    case cyprusLife
    case kolan
    case kamiloglu
    case burhan
    case girneState
    case lefkosaState
    case magusaState
    case lefkeState
    
    var title: String {
        switch self {
        case .nearEast:
            return "Yakın Doğu Üniversitesi Hastanesi"
        case .cyprusLife:
            return  "Cyprus Life Hospital"
        case .kolan:
            return "Kolan British Hospital"
        case .kamiloglu:
            return "Kamiloğlu Hastanesi"
        case .burhan:
            return "Dr Burhan Nalbantoğlu Develt Hastanesi"
        case .girneState:
            return "Girne Devlet Hastanesi"
        case .lefkosaState:
            return "Lefkoşa Devlet Hastanesi"
        case .magusaState:
            return "Mağusa Devlet Hastanesi"
        case .lefkeState:
            return "Lefke Devlet Hastanesi"
        }
    }
}
