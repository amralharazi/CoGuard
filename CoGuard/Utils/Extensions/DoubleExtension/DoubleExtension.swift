//
//  DoubleExtension.swift
//  CoGuard
//
//  Created by عمرو on 1.06.2023.
//

import Foundation

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
    
    func toDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format.literalMonthDateFormat
        let birthdate = Date(timeIntervalSince1970: self)
        return dateFormatter.string(from: birthdate)
    }
    
}
