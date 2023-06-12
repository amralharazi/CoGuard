//
//  APIManager.swift
//  CoGuard
//
//  Created by عمرو on 31.05.2023.
//

import Foundation
import Alamofire

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
}


class APIManager: APIManagerProtocol {
    
    func perform(_ request: RequestProtocol) async throws -> Data {
        
        if let url = URL(string: request.path) {
            print(url)
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url, method: request.requestType, parameters: request.params, encoding: request.encoding, headers: request.headers).responseData { response in
                    
                    debugPrint(response)
                    
                    switch response.result {
                        
                    case .success(let data):
                        print(String(data: data, encoding: .utf8) as Any)
                        continuation.resume(returning: data)
                        return
                    case .failure(let error):
                        print(error)
                        continuation.resume(throwing: error)
                        return
                    }
                }
            })
        } else {
            throw URLError(.badURL)
        }
    }
}
