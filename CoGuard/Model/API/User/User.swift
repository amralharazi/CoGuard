//
//  User.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation

struct User: Codable {
    let uid: String?
    var name: String
    let city: String?
    let sex: String
    var weight: String?
    var height: String?
    let email: String
    let hospital: String?
    let specialty: String?
    let riskStatus: String?
    var isDoctor: Bool
    let birthdate: String?
    let status: String?
    let phone: String?
    var profileImage: String?
    var hasCompletedProfile: Bool {
        weight != nil
    }
    
    init(uid: String? = nil, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.sex = dictionary["sex"] as? String ?? ""
        self.birthdate = dictionary["birthdate"] as? String
        self.weight = dictionary["weight"] as? String
        self.height = dictionary["height"] as? String
        self.hospital = dictionary["hospital"] as? String ?? ""
        self.specialty = dictionary["specialty"] as? String ?? ""
        self.status = dictionary["status"] as? String
        self.city = dictionary["city"] as? String
        self.phone = dictionary["phone"] as? String
        self.email = dictionary["email"] as? String ?? ""
        self.riskStatus = dictionary["riskStatus"] as? String ?? "Risk-Free"
        self.isDoctor = dictionary["isDoctor"] as? Bool ?? false
        self.profileImage = dictionary["profileImage"] as? String
    }
    
    func getBmi() -> Double {
        guard let weightString = weight,
              let weight = Double(weightString.digits),
              let heightString = height,
              let height = Double(heightString.digits) else {return 0.0}
        
        return  Double(weight) / pow(height, Double(2))
    }
    
    func getAge() -> Int {
        guard let birthdate = birthdate else {return 0}
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = Format.dateFormat
        let dateOfBirth = dateFormater.date(from: birthdate)
        let ageComponents = Calendar.current.dateComponents([.year], from:
                                                                dateOfBirth!, to: Date())
        
        return ageComponents.year ?? 0
    }
    
    mutating func setImageUrl(_ urlString: String) {
        self.profileImage = urlString
    }
}

