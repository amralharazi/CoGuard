//
//  VCExtension.swift
//  FollStar
//
//  Created by عمرو on 26.04.2022.
//

import UIKit
import SafariServices

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showLottieAnimation(){
        if let vc = self.tabBarController as? DashboardVC {
            self.view.isUserInteractionEnabled = false
            vc.showLoadingAnimation()
        } else if let vc = self.navigationController as? LottieCoveredNVC {
            self.view.isUserInteractionEnabled = false
            vc.showLoadingAnimation()
        }
    }
    
    func hideLottieAnimation(){
        if let vc = self.tabBarController as? DashboardVC {
            self.view.isUserInteractionEnabled = true
            vc.hideLoadingAnimation()
        } else if let vc = self.navigationController as? LottieCoveredNVC {
            self.view.isUserInteractionEnabled = true
            vc.hideLoadingAnimation()
        }
    }
    
    func showPopup(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                alertController.dismiss(animated: true, completion: completion)
            }
        }
    }
    
    func showWebScreenWith(url: URL) {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .fullScreen
        present(safariController, animated: true, completion: nil)
    }
    
    
    func showLocationDisabeledAlert(){
        let alertController = UIAlertController(title: "Access Denied", message: "Please allow access to location to show cases on map.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
        })
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func configureNavBar(titleColor: UIColor = .white,
                         backgoundColor: UIColor = .darkGreen,
                         tintColor: UIColor = .white,
                         hideShadow: Bool = false,
                         preferredLargeTitle: Bool = false){
        let title = navigationItem.title
        if let largeFont = preferredLargeTitle ? UIFont(name: AppFont.MontserratBold, size: 28) : UIFont(name: AppFont.MontserratMedium, size: 18),
           let mediumFont = UIFont(name: AppFont.MontserratMedium, size: 18){
            let largeAttrs =  [ NSAttributedString.Key.font: largeFont,
                                NSAttributedString.Key.foregroundColor: titleColor] as [NSAttributedString.Key : Any]
            
            let compactAttrs =  [ NSAttributedString.Key.font: mediumFont,
                                  NSAttributedString.Key.foregroundColor: titleColor] as [NSAttributedString.Key : Any]
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = largeAttrs
            navBarAppearance.titleTextAttributes = compactAttrs
            navBarAppearance.backgroundColor = backgoundColor
            navBarAppearance.shadowColor = hideShadow ? .clear : navBarAppearance.shadowColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
        }
    }
    
    // MARK:  Selector
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
