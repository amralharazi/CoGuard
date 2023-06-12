//
//  MaritalStatus.swift
//  CoGuard
//
//  Created by عمرو on 20.05.2023.
//

import Foundation

enum MaritalStatus: Int, CaseIterable {
    case married
    case single
    
    var title: String {
        switch self {
        case .married:
            return "Married"
        case .single:
            return "Single"
        }
    }
}
