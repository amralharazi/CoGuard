//
//  RequestManager.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation

protocol RequestManagerProtocol {
  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

class RequestManager: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol
  
  init(apiManager: APIManagerProtocol = APIManager(), parser: DataParserProtocol = DataParser()) {
    self.apiManager = apiManager
    self.parser = parser
  }
  
  
  func perform<T: Decodable>(_ request: RequestProtocol)
  async throws -> T {
    let data = try await apiManager.perform(request)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
}
