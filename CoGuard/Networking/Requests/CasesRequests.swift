//
//  CasesRequests.swift
//  CoGuard
//
//  Created by عمرو on 1.06.2023.
//

import Foundation
import Alamofire

enum CasesRequests: RequestProtocol{
    case fetchGlobalCases
    case fetchStatsForAllCountries
    
    var host: String {
        "https://covid-193.p.rapidapi.com"
    }
    
    var path: String {
        "\(host)/statistics"
    }
    
    var headers: HTTPHeaders {
        ["x-rapidapi-host": "covid-193.p.rapidapi.com",
         "x-rapidapi-key": Token.shared.apiKey]
    }
    
    var params: [String : Any] {
        var params = [String : Any] ()
        switch self {
        case .fetchGlobalCases:
            params["country"] = "all"
        default:
            break
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
    
    var requestType: HTTPMethod {
        .get
    }
}

