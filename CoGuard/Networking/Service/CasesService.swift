//
//  CasesService.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation
import Firebase

struct CasesService {
    static let shared = CasesService()
    
    func fetchAllLocations(completion: @escaping ([CaseLocation]) -> Void){
        var locations = [CaseLocation]()
        FirebaseDB.REF_LOCATIONS.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    guard let dictionary = childSnapshot.value as? [String: Any] else {
                        completion(locations)
                        return }
                    let location = CaseLocation(dictionary: dictionary)
                    locations.append(location)
                    completion(locations)
                }
            }
        }
    }
    
    func fetchMostObservedSymptoms(completion: @escaping(([String: Int], Int)) -> Void){
        var symptoms = [String: Int]()
        var totalCases = 0

        FirebaseDB.REF_MOST_SEEN_SYMPTOMS.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let totalSymptoms = snapshot.childrenCount - 1
                for child in snapshot.children {
                    if let symptom = child as? DataSnapshot {
                        if symptom.key.caseInsensitiveCompare("total") == .orderedSame {
                            totalCases = symptom.value as? Int ?? 0
                            continue
                        }
                        symptoms[symptom.key] = symptom.value as? Int
                    }
                    if symptoms.count == totalSymptoms{completion((symptoms, totalCases))}
                }
            } else {
                completion((symptoms, totalCases))
            }
        }
    }
}
