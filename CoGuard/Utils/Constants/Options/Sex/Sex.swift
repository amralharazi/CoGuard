//
//  Sex.swift
//  CoGuard
//
//  Created by عمرو on 18.05.2023.
//

import Foundation

enum Sex: Int, CaseIterable {
    case female
    case male
    
    var title: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        }
    }
}
