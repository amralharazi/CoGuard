//
//  PatientSymptom.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import Foundation

struct PatientSymptom {
    var id: Int
    var symptom: Symptom
    var rate: Int
    
    init(symptom: Symptom, rate: Int = 0) {
        self.id = symptom.rawValue
        self.symptom = symptom
        self.rate = rate
    }
}
