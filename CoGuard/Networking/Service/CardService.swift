//
//  CardService.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import Foundation
import Firebase

struct CardService {
    static let shared = CardService()
    
    func uploadAttachment(data: Data, isImage: Bool, completion: @escaping (Float?, URL?, Error?) -> Void){
        
        let fileName = NSUUID().uuidString + (isImage ? ".jpeg" : ".mov")
        let storageRef = FirebaseStorage.CARD_ATTACHMENTS.child(fileName)
        let uploadTask = storageRef.putData(data, metadata: nil) { (meta, error) in
            guard error == nil else {
                print(error)
                completion(nil, nil, error)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let url = url else {
                    print(error)
                    completion(nil, nil, error)
                    return
                }
                completion(1, url, nil)
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount)
            / Float(snapshot.progress!.totalUnitCount)
            completion(percentComplete, nil, nil)
        }
    }
    
    func fetchAllDoctors(completion: @escaping ([User]) -> Void){
        var doctors = [User]()
        FirebaseDB.REF_USERS.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    
                    if let dictionary = childSnapshot.value as? [String : Any],
                       let isDoctor = dictionary["isDoctor"] as? Bool,
                       isDoctor {
                        let doctorId = childSnapshot.key
                        let doctor = User(uid: doctorId, dictionary: dictionary)
                        doctors.append(doctor)
                        completion(doctors)
                    }
                }
            }
        }
    }
    
    func upload(card: ExaminationCard, completion: @escaping (Error?) -> Void ){
        guard let uid = Auth.auth().currentUser?.uid,
              let doctorId = card.details.doctorId else {
            completion(AppError.unexpectedError)
            return }
        
        var values = [String: Any]()
        let symptoms = Dictionary(uniqueKeysWithValues: card.symptoms.map{ ($0.symptom.databaseKey, $0.rate)})
        values["details"] = card.details.dict
        values["symptoms"] = symptoms
        values["attachments"] = Dictionary(uniqueKeysWithValues: card.attachments.map{ ($0.attachment.databaseKey, $0.stringUrl)})
        
        FirebaseDB.REF_EXAMINATION_CARDS.child(uid).childByAutoId().updateChildValues(values) { error, ref in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let cardId = ref.key else {
                completion(AppError.unexpectedError)
                return}
            
            updateOverall(symptoms: symptoms) { error in
                if let error = error {
                    print(error)
                    completion(error)
                }
            }
            
            FirebaseDB.REF_CARD_REVIEW_REQUESTS.child(doctorId).child(cardId).setValue(uid) { error, ref in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                if let probabilityString = card.details.probability,
                   let probability = Double(probabilityString),
                   probability >= 50,
                   let location = card.locaion {
                    
                    FirebaseDB.REF_LOCATIONS.child(uid).updateChildValues(["latitude": location.coordinate.latitude,
                                                                           "longitude": location.coordinate.longitude]) { error, ref in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        
                        let date = Date().timeIntervalSince1970
                        
                        FirebaseDB.REF_USERS.child(uid).updateChildValues(["riskStatus": "Risky",
                                                                           "lastUpdate": date])  { error, ref in
                            guard error == nil else {
                                completion(error)
                                return
                            }
                            
                            FirebaseDB.REF_RISKY_PATIENTS.updateChildValues([uid : date]) { error, ref in
                                guard error == nil else {
                                    completion(error)
                                    return
                                }
                                completion(nil)
                                return
                            }
                        }
                    }
                } else {
                    completion(nil)
                    return
                }
            }
        }
    }
    
    fileprivate func updateOverall(symptoms: [String: Int], completion: @escaping (Error?) -> Void) {
        FirebaseDB.REF_MOST_SEEN_SYMPTOMS.runTransactionBlock({(currentData: MutableData) -> TransactionResult in
            var incrementedSymptoms = [String: Int]()
            
            if let currentSymptoms = currentData.value as? [String: Int] {
                incrementedSymptoms = currentSymptoms
                for symptom in symptoms {
                    if symptom.value > 0,
                       let value = currentSymptoms[symptom.key] {
                        incrementedSymptoms[symptom.key] = value + 1
                    }
                }
                if let currentCasesCount = currentSymptoms["total"] {
                    incrementedSymptoms["total"] = currentCasesCount + 1
                }
            } else if currentData.childrenCount == 0 {
                for symptom in symptoms {
                    if symptom.value > 0 {
                        incrementedSymptoms[symptom.key] = 1
                    } else {
                        incrementedSymptoms[symptom.key] = 0
                    }
                }
                incrementedSymptoms["total"] = 1
            }
            currentData.value = incrementedSymptoms
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            completion(error)
        }
    }
    
    func fetchCards(forDoctor: Bool = false,
                    endingAt pred: Any,
                    completion: @escaping ([ExaminationCard]) -> Void){
        
        if forDoctor {
            fetchDoctorCards(endingAt: pred as? String) { cards in
                completion(cards)
            }
        } else {
            fetchPatienCards(endingAt: pred as? Double) { cards in
                completion(cards)
            }
        }
        
    }
    
    func fetchPatienCards(endingAt timestamp: Double? = nil,
                          completion: @escaping ([ExaminationCard]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var cards = [ExaminationCard]()
        
        FirebaseDB.REF_EXAMINATION_CARDS.child(uid).queryOrdered(byChild: "date").queryEnding(atValue: timestamp).queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
            if (snapshot.exists()) {
                for child in snapshot.children.reversed() {
                    if let childSnapshot = child as? DataSnapshot {
                        guard let dictionary = childSnapshot.value as? [String: Any] else { continue }
                        let card = ExaminationCard(id: childSnapshot.key, dictionary: dictionary)
                        cards.append(card)
                        completion(cards)
                    }
                }
            } else {
                completion(cards)
            }
        }
    }
    
    
    func fetchDoctorCards(endingAt childKey: String? = nil,
                          completion: @escaping ([ExaminationCard]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var cards = [ExaminationCard]()
        
        FirebaseDB.REF_CARD_REVIEW_REQUESTS.child(uid).queryEnding(atValue: nil, childKey: childKey).queryLimited(toLast: 10).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            for child in snapshot.children.reversed() {
                var totalCards =  snapshot.childrenCount
                if let childSnapshot = child as? DataSnapshot,
                   let patientId = childSnapshot.value as? String{
                    let cardId = childSnapshot.key
                    FirebaseDB.REF_EXAMINATION_CARDS.child(patientId).child(cardId).observeSingleEvent(of: .value) { snapshot in
                        if snapshot.exists() {
                            print(snapshot)
                            guard let dictionary = snapshot.value as? [String: Any] else { return }
                            let card = ExaminationCard(id: snapshot.key, dictionary: dictionary)
                            cards.append(card)
                            completion(cards)
                        } else {
                            FirebaseDB.REF_CARD_REVIEW_REQUESTS.child(uid).child(cardId).removeValue()
                            totalCards -= 1
                        }
                        if totalCards == cards.count {completion(cards)}
                    }
                }
            }
        }
    }
    
    func add(feedback: String, toCardWith cardId: String, fromPatientWith patientId: String, completion: @escaping (Error?) -> Void){
        FirebaseDB.REF_EXAMINATION_CARDS.child(patientId).child(cardId).child("details").updateChildValues(["feedback": feedback]) { error, ref in
            completion(error)
        }
    }
}
