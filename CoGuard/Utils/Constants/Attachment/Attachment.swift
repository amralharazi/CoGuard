//
//  CardAttachment.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import Foundation

enum Attachment: Int, CaseIterable {
    case leftEar
    case rightEar
    case throat
    case faceRecording
    
    var title: String {
        switch self {
        case .leftEar:
            return "Left ear photo"
        case .rightEar:
            return "Right ear photo"
        case .throat:
            return "Throat photo"
        case .faceRecording:
            return "Face recording"
        }
    }
    
    var databaseKey: String {
        switch self {
        case .leftEar:
            return "leftEar"
        case .rightEar:
            return "rightEar"
        case .throat:
            return "throat"
        case .faceRecording:
            return "faceRecording"
        }
    }
}
