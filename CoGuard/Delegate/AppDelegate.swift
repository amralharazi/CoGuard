//
//  AppDelegate.swift
//  CoGuard
//
//  Created by عمرو on 16.05.2023.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UserService.shared.listenToUserChanges()
        TokenService.shared.getKey()
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        return true
    }
}

