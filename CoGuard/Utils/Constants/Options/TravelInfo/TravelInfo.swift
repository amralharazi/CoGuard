//
//  TravelInfo.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import Foundation

enum TravelInfo: Int, CaseIterable {
    case beenToSouthernCyprus
    case beenAbroadRecently
    case contactedComingFromAbroad
    case beenToHealthFacility
    case conactedIllPerson
    
    var id: Int {
        rawValue
    }
    
    var title: String {
        switch self {
        case .beenToSouthernCyprus:
            return "Have you traveled to Southern Cyprus in the last 14 days?"
        case .beenAbroadRecently:
            return "Have you been abroad in the last 14 days?"
        case .contactedComingFromAbroad:
            return "Have you been in contact with someone coming from abroad in the last 14 days?"
        case .beenToHealthFacility:
            return "Have you been to any health facility in the last 14 days?"
        case .conactedIllPerson:
            return "Have you been in contact with someone having any respiratory disease in the last 14 days?"
        }
    }
    
    var databaseKey: String {
        switch self {
        case .beenToSouthernCyprus:
            return "beenToSouthernCyprus"
        case .beenAbroadRecently:
            return "beenAbroadRecently"
        case .contactedComingFromAbroad:
            return "contactedComingFromAbroad"
        case .beenToHealthFacility:
            return "beenToHealthFacility"
        case .conactedIllPerson:
            return "conactedIllPerson"
        }
    }
}
