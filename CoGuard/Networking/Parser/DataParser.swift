//
//  DataParser.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation

protocol DataParserProtocol {
  func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
  private var jsonDecoder: JSONDecoder

  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
  }

  func parse<T: Decodable>(data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}
