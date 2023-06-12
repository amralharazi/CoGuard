//
//  AppError.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation

public enum AppError: Error {
    case usernameAlreadyExists
    case signOutError
    case uploadingPhotoFailed
    case noSuchUser
    case patientAlreadyAdded
    case unexpectedError
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .usernameAlreadyExists:
            return NSLocalizedString("User already exists with the same username!", comment: "AppError")
        case .signOutError:
            return NSLocalizedString("Logout Failed.", comment: "AppError")
        case .uploadingPhotoFailed:
            return NSLocalizedString("Uploading profile photo failed!.", comment: "AppError")
        case .noSuchUser:
            return NSLocalizedString("No user matches the entered credentials.", comment: "AppError")
        case .patientAlreadyAdded:
            return NSLocalizedString("Patient is already added to your pateint list.", comment: "AppError")
        case .unexpectedError:
            return NSLocalizedString("An unexpected error happened. Please try again.", comment: "AppError")
        }
    }
}
