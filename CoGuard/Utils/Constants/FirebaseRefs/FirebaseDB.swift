//
//  FirebaseDB.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation
import Firebase

struct FirebaseDB {
    static let DB_REF = Database.database().reference()
    
    static let REF_USERS = DB_REF.child("users")
    static let REF_USER_MEDICAL_CONDITIONS = DB_REF.child("medical_conditions")
    static let REF_TRAVEL_INFO = DB_REF.child("travel_info")
    static let REF_EXAMINATION_CARDS = DB_REF.child("examination_cards")
    static let REF_CARD_REVIEW_REQUESTS = DB_REF.child("review_requests")
    static let REF_SUBMITTED_CARDS = DB_REF.child("submitted_cards")
    static let REF_LOCATIONS = DB_REF.child("locations")
    static let REF_HOSPITALS = DB_REF.child("hospitals")
    static let REF_MOST_SEEN_SYMPTOMS = DB_REF.child("most_seen_symptoms")
    static let REF_RISKY_PATIENTS = DB_REF.child("risky_patients")
    static let REF_TOKEN = DB_REF.child("token")
}
