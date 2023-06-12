//
//  Articles.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation

struct Articles: Codable {
    var articles: [News]?
    var page: Int?
    var total_pages: Int?
}
