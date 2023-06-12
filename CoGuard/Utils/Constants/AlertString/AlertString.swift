//
//  AlertString.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import Foundation


enum AlertString {
    case error(ErrorType)
    case feedback(FeedbackType)
    
    enum ErrorType: String {
        case title = "Error"
        case noProfilePhoto = "Please add a photo to your profile."
        case termsNotAccepted = "Please read and accept the terms and coditions before proceeding."
        case emptyEmail = "Please don't leave email field empty."
        case invalidEmail = "Please enter a valid email address"
        case emptyPassword = "Please don't leave password field empty."
        case emptyNewPassword = "Please don't leave new password field empty."
        case emailNotVerified = "Email hasn't been verified. Please verify your email to be able to use the app."
        case locationCantBeShown = "Location cannot be shown on the map."
        case unexpectedError = "An unexpected error happened. Please try again."
        case noDataToBePlotted = "Found no data to be plotted."
    }
    
    enum FeedbackType: String {
        case emailResent = "Verification email has been resent. Please check your inbox again."
        case resetPasswordEmailSent = "Password reset email has been sent to your email. Please check your inbox."
        case passwordChanged = "Password has been changed successfully."
        case profileUpdated = "Profile has been updated successfully."
        case medicalConditionsUpdated = "Medical conditions have been updated successfully."
        case cardSent = "Examination card has been sent successfully."
        case attention = "Attentions"
        case wantToDeleteAccount = "By proceeding, your account and data will be permanently deleted. Continue?"
        case emptyFeedback = "Feedback field is empty."
        case feedbackSent = "Feedback has been sent."
    }
}
