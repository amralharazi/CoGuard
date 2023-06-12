//
//  NewsRequests.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation
import Alamofire

enum NewsRequests: RequestProtocol {
    case getNews(startingPage: Int)
    
    var path: String {
        "https://covid-19-news.p.rapidapi.com/v1/covid"
    }
    
    var headers: HTTPHeaders {
        ["x-rapidapi-host": "covid-19-news.p.rapidapi.com",
         "x-rapidapi-key": Token.shared.apiKey]
    }
    
    var params: [String : Any] {
        var params = ["q": "covid",
                      "lang": "en",
                      "from": "today",
                      "media": "media"]
        
        switch self {
        case let .getNews(startingPage):
            params["page"] = "\(startingPage)"
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
