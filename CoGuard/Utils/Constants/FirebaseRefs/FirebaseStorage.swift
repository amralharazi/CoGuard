//
//  FirebaseStorage.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation
import FirebaseStorage

struct FirebaseStorage {
    static let STORAGE = Storage.storage().reference()
    
    static let PROFILE_PHOTOS = STORAGE.child("profile_photos")
    static let CARD_ATTACHMENTS = STORAGE.child("card_attachments")
}
