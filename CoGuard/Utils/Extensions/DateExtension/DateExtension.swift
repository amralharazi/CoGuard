//
//  DateExtension.swift
//  CoGuard
//
//  Created by عمرو on 5.06.2023.
//

import Foundation

extension Date {
    var readable: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format.dateFormat
        return  dateFormatter.string(from: self)
    }
}
