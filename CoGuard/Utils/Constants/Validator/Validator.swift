//
//  Validator.swift
//  SUPEREAD
//
//  Created by عمرو on 16.06.2022.
//

import Foundation


class Validator {
    
    static let shared = Validator()
    
    func isValidEmail(_ email: String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    func isValidUsername(_ username: String) -> Bool {
        return username.count <= 26 ? true : false
    }
    
    func arePasswordEqual(_ password: String, _ repeatedPassword: String) -> Bool {
        return password == repeatedPassword
    }
    
    func isValidName(_ name: String) -> Bool {
        return name.count <= 26
    }
    
    func isValidAddrese(_ address: String) -> Bool {
        return address.count <= 125
    }
}
