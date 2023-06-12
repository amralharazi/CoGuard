//
//  AuthManagement.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation
import Firebase

struct AuthService {
    static let shared = AuthService()
    
    func register(user: User, with credentials: AuthCredentials, profilePhotoData: Data, completion: @escaping (Error?) -> Void){
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            if let _ = result {
                UserService.shared.uploadPhoto(data: profilePhotoData) { imgUrl, error in
                    if let error = error {
                        print(error)
                        completion(error)
                        return
                    }
                    
                    if let imgUrl = imgUrl {
                        var userWithPhoto = user
                        userWithPhoto.setImageUrl(imgUrl.absoluteString)
                        UserService.shared.add(user: userWithPhoto) { error in
                            if let error = error {
                                print(error)
                                completion(error)
                                return
                            }
                            
                            sendVerificationEmail { error in
                                if let error = error {
                                    print(error)
                                    completion(error)
                                    return
                                }
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loginUser(with credentails: AuthCredentials, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: credentails.email, password: credentails.password) { result, error in
            
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            if let result = result {
                
                if result.user.isEmailVerified {
                    
                    UserService.shared.fetchUser { user, error in
                        if let error = error {
                            print(error)
                            completion(nil, error)
                            return
                        }
                        
                        if let user = user {
                            UserService.shared.listenToUserChanges()
                            TokenService.shared.getKey()
                            completion(user, nil)
                            return
                        }
                    }
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func sendVerificationEmail(completion: @escaping (Error?) -> Void){
        guard let user = Auth.auth().currentUser else {return}
        user.sendEmailVerification() { error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func resetPassword(for email: String, completion: @escaping (Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    func change(password: String, for email: String, to newPassword: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { result, error in
            guard error == nil else {
                completion(error)
                return }
            user.updatePassword(to: newPassword, completion: { (error) in
                completion(error)
            })
        }
    }
    
    func logout(completion: @escaping (Error?) -> Void){
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteAccount(completion: @escaping(Error?) -> Void){
        guard let user = Auth.auth().currentUser else {
            completion(AppError.unexpectedError)
            return}
        
        FirebaseDB.REF_EXAMINATION_CARDS.child(user.uid).removeValue { error, ref in
            guard  error == nil else {
                completion(error)
                return
            }
            
            FirebaseDB.REF_LOCATIONS.child(user.uid).removeValue { error, ref in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                FirebaseDB.REF_USER_MEDICAL_CONDITIONS.child(user.uid).removeValue { error, ref in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    
                    FirebaseDB.REF_RISKY_PATIENTS.child(user.uid).removeValue { error, ref in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        FirebaseDB.REF_TRAVEL_INFO.child(user.uid).removeValue { error, ref in
                            guard error == nil else {
                                completion(error)
                                return
                            }
                            FirebaseDB.REF_USERS.child(user.uid).removeValue { error, ref in
                                guard error == nil else {
                                    completion(error)
                                    return
                                }
                                
                                user.delete { error in
                                    guard error == nil else {
                                        completion(error)
                                        return
                                    }
                                    completion(error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
