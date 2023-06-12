//
//  City.swift
//  CoGuard
//
//  Created by عمرو on 20.05.2023.
//

import Foundation

enum City: Int, CaseIterable {
    case gazimagusa
    case girne
    case guzelyurt
    case iskele
    case lefke
    case lefkose
    
    var title: String {
        switch self {
        case .gazimagusa:
            return "Gazimağusa"
        case .girne:
            return "Girne"
        case .guzelyurt:
            return "Güzelyurt"
        case .iskele:
            return "İskele"
        case .lefke:
            return "Lefke"
        case .lefkose:
            return "Lefkoşa"
        }
    }
}
