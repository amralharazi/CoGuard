//
//  Symptom.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import Foundation

enum Symptom: Int, CaseIterable {
    case lossOfSmellAndTaste
    case abdominalPain
    case anorexia
    case bluishFaceAndLips
    case bodyAches
    case chestPain
    case chillsAndShaking
    case confusion
    case delirium
    case diarrhea
    case dizziness
    case fatigue
    case fever
    case feelingUnwell
    case headache
    case hoarseVoice
    case runnyNose
    case nasalStufiness
    case nausea
    case ocularReaction
    case caugh
    case shortnessOfBreath
    case skinRash
    case inappetence
    case sneezing
    case soreThroat
    case sputum
    case vomiting
    
    var title: String {
        switch self {
        case .lossOfSmellAndTaste:
            return "Loss of smell and taste"
        case .abdominalPain:
            return "Abdominal pain"
        case .anorexia:
            return "Anorexia"
        case .bluishFaceAndLips:
            return "Bluish face and lips"
        case .bodyAches:
            return "Body aches"
        case .chestPain:
            return "Chest pain"
        case .chillsAndShaking:
            return "Chills and shaking"
        case .confusion:
            return "Confusion"
        case .delirium:
            return "Delirium"
        case .diarrhea:
            return "Diarrhea"
        case .dizziness:
            return "Dizziness"
        case .fatigue:
            return "Fatigue"
        case .fever:
            return "Fever"
        case .feelingUnwell:
            return "Feeling unwell"
        case .headache:
            return "Headache"
        case .hoarseVoice:
            return "Hoarse voice (Hoarseness)"
        case .runnyNose:
            return "Runny nose"
        case .nasalStufiness:
            return "Nasal stuffiness"
        case .nausea:
            return "Nausea"
        case .ocularReaction:
            return "Ocular reaction"
        case .caugh:
            return "Persistent cough"
        case .shortnessOfBreath:
            return "Shortness of breath"
        case .skinRash:
            return "Skin rash"
        case .inappetence:
            return "Inappetence"
        case .sneezing:
            return "Sneezing"
        case .soreThroat:
            return "Sore throat"
        case .sputum:
            return "Sputum"
        case .vomiting:
            return "Vomiting"
        }
    }
    
    var databaseKey: String {
        switch self {
        case .lossOfSmellAndTaste:
            return "lossOfSmellAndTaste"
        case .abdominalPain:
            return "abdominalPain"
        case .anorexia:
            return "anorexia"
        case .bluishFaceAndLips:
            return "bluishFaceAndLips"
        case .bodyAches:
            return "bodyAches"
        case .chestPain:
            return "chestPain"
        case .chillsAndShaking:
            return "chillsAndShaking"
        case .confusion:
            return "confusion"
        case .delirium:
            return "delirium"
        case .diarrhea:
            return "diarrhea"
        case .dizziness:
            return "dizziness"
        case .fatigue:
            return "fatigue"
        case .fever:
            return "fever"
        case .feelingUnwell:
            return "feelingUnwell"
        case .headache:
            return "headache"
        case .hoarseVoice:
            return "hoarseVoice"
        case .runnyNose:
            return "runnyNose"
        case .nasalStufiness:
            return "nasalStufiness"
        case .nausea:
            return "nausea"
        case .ocularReaction:
            return "ocularReaction"
        case .caugh:
            return "caugh"
        case .shortnessOfBreath:
            return "shortnessOfBreath"
        case .skinRash:
            return "skinRash"
        case .inappetence:
            return "inappetence"
        case .sneezing:
            return "sneezing"
        case .soreThroat:
            return "soreThroat"
        case .sputum:
            return "sputum"
        case .vomiting:
            return "vomiting"
        }
    }
}
