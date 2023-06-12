//
//  RequestProtocol.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation
import Alamofire

protocol RequestProtocol {
  var path: String { get }
  var headers: HTTPHeaders { get }
  var params: [String: Any] { get }
  var encoding: ParameterEncoding { get }
  var addAuthorizationToken: Bool { get }
  var requestType: HTTPMethod { get }
}

extension RequestProtocol {
    
  var addAuthorizationToken: Bool {
    true
  }

    var params: [String: Any] {
    [:]
  }
  
  var urlParams: [String: String?] {
    [:]
  }
  
  var headers: HTTPHeaders {
    ["Content-Type": "application/json",
     "Accept": "application/json"]
  }
}

