//
//  ResetPasswordVC.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit

class ResetPasswordVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var emailTextField: RoundedTextField!
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        hideKeyboardWhenTappedAround()
    }
    
    private func getEmail() -> String? {
        if let email = emailTextField.text,
           !email.isEmpty {
            
            if Validator.shared.isValidEmail(email) {
                return email
            } else {
                showPopup(message: AlertString.ErrorType.invalidEmail.rawValue)
            }
        } else {
            showPopup(message: AlertString.ErrorType.emptyEmail.rawValue)
        }
        return nil
    }
    
    // MARK: Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if let email = getEmail() {
            resetPassword(for: email)
        }
    }
    
    // MARK: Requests
    private func resetPassword(for email: String) {
        showLoadingAnimation()
        
        AuthService.shared.resetPassword(for: email) {[weak self] error in
            
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            } else {
                showPopup(message: AlertString.FeedbackType.resetPasswordEmailSent.rawValue) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
