//
//  EncodableExtension.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation


extension Encodable {
    var dict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
