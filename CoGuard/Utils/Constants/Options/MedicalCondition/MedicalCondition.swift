//
//  MedicalCondition.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import Foundation

enum MedicalCondition: Int, CaseIterable {
    case ards
    case pneumonia
    case hadCovid
    case hadSars
    case beenToIcu
    case lungDisease
    case diabetes
    case hypertension
    case liverDisease
    case kidneyDisease
    case heartDisease
    case geneticDisorder
    case booldCancer
    case cancer
    case takesChemo
    case immuneSystemDisorder
    case regulrPainkillers
    case cortisone
    case thalassemia
    
    var title: String {
        switch self {
        case .ards:
            return "Acute Respiratory Distress Syndrome (ARDS)"
        case .pneumonia:
            return "Pneumonia"
        case .hadCovid:
            return "Have you had Covid-19"
        case .hadSars:
            return "Have you tested positive for SARS-Cov-2"
        case .beenToIcu:
            return "Have you been to an ICU?"
        case .lungDisease:
            return "Chronic lung disease"
        case .diabetes:
            return "Diabetes"
        case .hypertension:
            return "Hypertension"
        case .liverDisease:
            return "Chronic liver disease"
        case .kidneyDisease:
            return "Chronic kidney disease"
        case .heartDisease:
            return "Chronic heart disease"
        case .geneticDisorder:
            return "Genetic disorder"
        case .booldCancer:
            return "Blood cancer (Hematological Cancer)"
        case .cancer:
            return "Any other cancer"
        case .takesChemo:
            return "Taking chemotherapy"
        case .immuneSystemDisorder:
            return "Immune system disorder"
        case .regulrPainkillers:
            return "Taking Rheumatic medications or painkillers regularly"
        case .cortisone:
            return "Taking Immunosuppressive drugs (Cortisone treatment)"
        case .thalassemia:
            return "Carrier or patient of Thalassemia"
        }
    }
    
    var databaseKey: String {
        switch self {
        case .ards:
            return "ards"
        case .pneumonia:
            return "pneumonia"
        case .hadCovid:
            return "hadCovid"
        case .hadSars:
            return "hadSars"
        case .beenToIcu:
            return "beenToIcu"
        case .lungDisease:
            return "lungDisease"
        case .diabetes:
            return "diabetes"
        case .hypertension:
            return "hypertension"
        case .liverDisease:
            return "liverDisease"
        case .kidneyDisease:
            return "kidneyDisease"
        case .heartDisease:
            return "heartDisease"
        case .geneticDisorder:
            return "geneticDisorder"
        case .booldCancer:
            return "booldCancer"
        case .cancer:
            return "cancer"
        case .takesChemo:
            return "takesChemo"
        case .immuneSystemDisorder:
            return "immuneSystemDisorder"
        case .regulrPainkillers:
            return "regulrPainkillers"
        case .cortisone:
            return "cortisone"
        case .thalassemia:
            return "thalassemia"
        }
    }
}
