//
//  GlobalStats.swift
//  CoGuard
//
//  Created by عمرو on 1.06.2023.
//

import Foundation

struct CovidStatsResponse: Codable {
    let response: [RegionStats]?
}

struct RegionStats: Codable {
    let country: String?
    let cases: CasesStats?
    let deaths: DeathsStats?
}

struct CasesStats: Codable {
    let new: String?
    let active: Int?
    let critical: Int?
    let recovered: Int?
    let total: Int?
}

struct DeathsStats: Codable {
    let new: String?
    let total: Int?
}
