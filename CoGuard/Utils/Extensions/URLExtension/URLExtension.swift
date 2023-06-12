//
//  URLExtension.swift
//  CoGuard
//
//  Created by عمرو on 10.06.2023.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var isImageFile: Bool {
        UTType(filenameExtension: pathExtension)?.conforms(to: .image) ?? false
    }
}
