//
//  CardAttachment.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import Foundation

struct CardAttachment {
    var id: Int
    var attachment: Attachment
    var progress: Float?
    var stringUrl: String?
    
    init(attachment: Attachment, stringUrl: String? = nil) {
        self.id = attachment.rawValue
        self.attachment = attachment
        self.stringUrl = stringUrl
    }
}
