//
//  StringExtension.swift
//  CoGuard
//
//  Created by عمرو on 17.05.2023.
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func camelCaseToWords() -> String {
        unicodeScalars.reduce("") {
            guard CharacterSet.uppercaseLetters.contains($1),
                  $0.count > 0
            else { return $0 + String($1) }
            return ($0 + " " + String($1))
        }
    }
    
    var capitalizedFirstLetter:String {
        let string = self.lowercased()
        return string.replacingCharacters(in: startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
}
