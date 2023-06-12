//
//  UserManagement.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    private init () {}
    
    func uploadPhoto(data: Data, completion: @escaping (URL?, Error?) -> Void){
        
        let fileName = NSUUID().uuidString+".jpeg"
        let storageRef = FirebaseStorage.PROFILE_PHOTOS.child(fileName)
        storageRef.putData(data, metadata: nil) { (meta, error) in
            guard error == nil else {
                print(error)
                completion(nil, error)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let url = url else {
                    print(error)
                    completion(nil, error)
                    return
                }
                completion(url, nil)
            }
        }
    }
    
    func add(user: User, completion: @escaping (Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid,
              let values = user.dict else { return }
        
        FirebaseDB.REF_USERS.child(uid).updateChildValues(values) { error, ref in
            guard error == nil else {
                print(error)
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func fetchUser(with id: String? = Auth.auth().currentUser?.uid, completion: @escaping (User?, Error?) -> Void){
        guard let uid = id else {
            completion(nil, AppError.noSuchUser)
            return}
        FirebaseDB.REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let user = User(uid: uid, dictionary: dictionary)
                completion(user, nil)
            } else {
                completion(nil, AppError.noSuchUser)
            }
        }
    }
    
    func updateUser(details: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        FirebaseDB.REF_USERS.child(uid).updateChildValues(details) { error, ref in
            guard error == nil else {
                print(error)
                completion(error)
                return
            }
            
            fetchUser { user, error in
                if let error = error {
                    print(error)
                    completion(error)
                    return
                }
                
                if let user = user {
                    UniversalFuncs.shared.storeDataOf(user: user)
                    completion(nil)
                    return
                }
            }
        }
    }
    
    func listenToUserChanges(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseDB.REF_USERS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            UniversalFuncs.shared.storeDataOf(user: user)
        }
    }
    
    func removeObservers(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseDB.REF_USERS.child(uid).removeAllObservers()
    }
    
    func updateUser(medicalConditions: [String: Bool], completion: @escaping (Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseDB.REF_USER_MEDICAL_CONDITIONS.child(uid).updateChildValues(medicalConditions) { error, ref in
            completion(error)
        }
    }
    
    func getMedicalConditions(forUserWith id: String? = Auth.auth().currentUser?.uid, completion: @escaping ([String: Bool]?) -> Void){
        guard let uid = id else {return}
        FirebaseDB.REF_USER_MEDICAL_CONDITIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let conditions = snapshot.value as? [String : Bool] else {
                completion(nil)
                return}
            completion(conditions)
        }
    }
    
    func updateUser(travelInfo: [String: Bool], completion: @escaping (Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseDB.REF_TRAVEL_INFO.child(uid).updateChildValues(travelInfo) { error, ref in
            completion(error)
        }
    }
    
    func getTravelInfo(forUserWith id: String? = Auth.auth().currentUser?.uid, completion: @escaping ([String: Bool]?) -> Void){
        guard let uid = id else {return}
        FirebaseDB.REF_TRAVEL_INFO.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let travelInfo = snapshot.value as? [String : Bool] else {
                completion(nil)
                return}
            completion(travelInfo)
        }
    }
}
