//
//  SymptomRate.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

enum SymptomRate: Int, CaseIterable {
    case notObserved
    case low
    case moderate
    case severe
    
    var selectedColor: UIColor {
        switch self {
        case .notObserved:
            return .skyBlue
        case .low:
            return .yellow
        case .moderate:
            return .orange
        case .severe:
            return .systemRed
        }
    }
}
