//
//  HospitalsManagement.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation
import Firebase

struct HospitalService {
    static let shared = HospitalService()
    
    func fetchNearbyHospitals(completion: @escaping ([NearbyHospital]?) -> Void){
        var hospitals = [NearbyHospital]()
        
        FirebaseDB.REF_HOSPITALS.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    guard let dictionary = childSnapshot.value as? [String: Any] else {
                        completion(hospitals)
                        return }
                    let hospital = NearbyHospital(dictionary: dictionary)
                    hospitals.append(hospital)
                    completion(hospitals)
                }
            }
        }
    }
}
