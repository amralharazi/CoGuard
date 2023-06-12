//
//  UniversalFuncs.swift
//  SUPEREAD
//
//  Created by عمرو on 17.06.2022.
//

import Foundation

struct UniversalFuncs {
    static let shared = UniversalFuncs()
    
    func storeDataOf(user: User){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "currentUser")
        } catch {
            print("Unable to Encode User (\(error))")
        }
    }
    
    func getCurrentUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                let decoder = JSONDecoder()
                let currentUser = try decoder.decode(User.self, from: data)
                return currentUser
            } catch {
                print("Unable to Decode User (\(error))")
            }
        }
        return nil
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
