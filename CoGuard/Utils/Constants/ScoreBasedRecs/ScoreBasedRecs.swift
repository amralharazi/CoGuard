//
//  ScoreBasedRecs.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation

enum ScoreBasedRecs: Int {
    case severe
    case moderate
    case normal
        
    var recs: [String] {
        switch self {
        case .severe:
            return ["You need to seek medical attention / hospitalization, but call by telephone in advance if possible, and follow the directions of your local health authority.",
                    "You need to use personal protective equipment.",
                    "You are at higher risk of Covid-19 according to your Online Covid-19 test result, please do not be panic.",
                    "Please observe your health conditions and symptoms closely.",
                    "Consult your doctor for a physical examination as soon as possible.",
                    "Have Real-Time PCR (RT-qPCR) test for SARS-CoV-2."]
        case .moderate:
            return ["Continue online tests.",
                    "You need to wash your hands with soap and water often, and for at least 20 seconds.",
                    "You need to practice good respiratory hygiene, and avoid touching the eyes, nose or mouth with unwashed hands.",
                    "You need to rest.",
                    "You need to drink plenty of fluids.",
                    "Consult your doctor to get an over-the-counter pain reliever that's best for you.",
                    "Try to keep your temperature at normal levels such as by applying a cold towel, taking a warm shower.",
                    "Have someone to bring you supplies.",
                    "Stay home and self-isolate even with mild or moderate symptoms such as cough, headache, mild fever, chills with repeated shaking, deep cough, fatigue, body aches, muscle pain, general feeling of being unwell, until you recover.",
                    "Please observe your health conditions and symptoms closely.",
                    "You have a medium-to-risk of Covid-19 according to your Online Covid-19 test result, contact your doctor, please do not be panic."]
        case .normal:
            return ["Continue online tests.",
                    "You need to wash your hands with soap and water often, and for at least 20 seconds.",
                    "You need to practice good respiratory hygiene, and avoid touching the eyes, nose or mouth with unwashed hands.",
                    "Stay home and self-isolate even with minor symptoms such as cough, headache, mild fever, until you recover.",
                    "Please observe your health conditions and symptoms closely."]
        }
    }
}
