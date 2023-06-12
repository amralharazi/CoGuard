//
//  SceneDelegate.swift
//  CoGuard
//
//  Created by عمرو on 16.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            if UniversalFuncs.shared.getCurrentUser() == nil {
                let storyboard = UIStoryboard(name: Storyboard.Login, bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.LoginVC)
                window.rootViewController = initialViewController
                self.window = window
                window.makeKeyAndVisible()
                
            } else if UniversalFuncs.shared.getCurrentUser() != nil,
                      UniversalFuncs.shared.getCurrentUser()?.weight == nil {
                let storyboard = UIStoryboard(name: Storyboard.CompleteProfile, bundle: nil)
                if let initialViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CompleteProfileVC) as? CompleteProfileVC {
                    window.rootViewController = initialViewController
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
