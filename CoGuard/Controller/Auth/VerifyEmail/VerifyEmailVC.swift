//
//  VerifyEmailVC.swift
//  CoGuard
//
//  Created by عمرو on 25.05.2023.
//

import UIKit

class VerifyEmailVC: LottieCoveredVC {
    
    // MARK: Properties
    var credentials: AuthCredentials?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        guard let credentials = credentials else {return}
        showLoadingAnimation()
        
        AuthService.shared.loginUser(with: credentials) {[weak self] user, error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if user == nil && error == nil {
                self.showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                               withMessage: AlertString.ErrorType.emailNotVerified.rawValue)
                return
            }
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            }
            
            if let user = user {
                UniversalFuncs.shared.storeDataOf(user: user)
                self.goToCompleteProfileScreen()
            }
        }
    }
    
    @IBAction func resendEmailBtnPressed(_ sender: Any) {
        showLoadingAnimation()
        
        AuthService.shared.sendVerificationEmail { [weak self] error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            } else {
                showPopup(message: AlertString.FeedbackType.emailResent.rawValue)
            }
        }
    }
}

// MARK: Navigations
extension VerifyEmailVC {
    private func goToCompleteProfileScreen(){
        let storyboard = UIStoryboard(name: Storyboard.CompleteProfile, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CompleteProfileVC) as? CompleteProfileVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
