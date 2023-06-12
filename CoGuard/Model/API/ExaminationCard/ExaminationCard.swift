//
//  ExaminationCard.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation
import CoreLocation

struct ExaminationCard {
    var id: String?
    var locaion: CLLocation?
    var symptoms = [PatientSymptom]()
    var attachments = [CardAttachment]()
    var details = ExaminationCardDetails()

    init(id: String? = nil, dictionary: [String: Any]? = nil) {
        self.id = id
        self.details = ExaminationCardDetails(dictionary: dictionary?["details"] as? [String: Any])
        if let symptoms = dictionary?["symptoms"] as? [String: Int] {
            for case let symptom in Symptom.allCases {
                self.symptoms.append(PatientSymptom(symptom: symptom, rate: symptoms[symptom.databaseKey] ?? 0))
            }
        }
        
        if let attachments = dictionary?["attachments"] as? [String: String] {
            for case let attachment in Attachment.allCases {
                self.attachments.append(CardAttachment(attachment: attachment, stringUrl: attachments[attachment.databaseKey]))
            }
        }
    }
}
