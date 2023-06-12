//
//  ExaminationCardDetails.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation

struct ExaminationCardDetails: Codable {
    var date: Double?
    var feedback: String?
    var hospital: String?
    var doctorId: String?
    var patientId: String?
    var doctorName: String?
    var patientName: String?
    var probability: String?
    var scoreBasedCase: Int?
    var bodyTemperature: String?
    
    init(dictionary: [String: Any]? = nil) {
        self.date = dictionary?["date"] as? Double
        self.doctorId = dictionary?["doctorId"] as? String
        self.doctorName = dictionary?["doctorName"] as? String
        self.patientName = dictionary?["patientName"] as? String
        self.patientId = dictionary?["patientId"] as? String
        self.probability = dictionary?["probability"] as? String
        self.scoreBasedCase = dictionary?["scoreBasedCase"] as? Int
        self.bodyTemperature = dictionary?["bodyTemperature"] as? String
        self.hospital = dictionary?["hospital"] as? String
        self.feedback = dictionary?["feedback"] as? String
    }
}
